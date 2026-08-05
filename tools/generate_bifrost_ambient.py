#!/usr/bin/env python3
"""Synthesize the original ambient cue for The Oath at Bifrost."""

from __future__ import annotations

import argparse
import wave
from pathlib import Path

import numpy as np


SAMPLE_RATE = 48_000
DURATION = 12.0


def equal_power_pan(signal: np.ndarray, pan: float) -> np.ndarray:
    angle = (pan + 1.0) * np.pi / 4.0
    return np.column_stack((signal * np.cos(angle), signal * np.sin(angle)))


def window(
    t: np.ndarray,
    start: float,
    duration: float,
    attack: float,
    release: float,
) -> np.ndarray:
    local = t - start
    active = (local >= 0.0) & (local <= duration)
    env = np.zeros_like(t)
    env[active] = 1.0

    if attack > 0.0:
        rising = active & (local < attack)
        env[rising] = np.sin(np.pi * local[rising] / (2.0 * attack)) ** 2

    if release > 0.0:
        falling = active & (local > duration - release)
        remaining = duration - local[falling]
        env[falling] = np.sin(np.pi * remaining / (2.0 * release)) ** 2

    return env


def add_drone(t: np.ndarray, mix: np.ndarray) -> None:
    fundamentals = (
        (73.416, -0.35, 0.115),   # D2
        (110.000, 0.30, 0.075),   # A2
        (146.832, -0.05, 0.050),  # D3
    )
    long_env = window(t, 0.0, DURATION, 1.8, 2.2)

    for index, (frequency, pan, level) in enumerate(fundamentals):
        voice = np.zeros_like(t)
        slow_breath = 0.82 + 0.18 * np.sin(2.0 * np.pi * (0.055 + index * 0.012) * t + index)
        for harmonic in range(1, 7):
            amplitude = 1.0 / (harmonic ** 1.55)
            detune = 1.0 + (harmonic - 3) * 0.00035
            phase = index * 0.9 + harmonic * 0.37
            voice += amplitude * np.sin(2.0 * np.pi * frequency * harmonic * detune * t + phase)
        voice *= level * slow_breath * long_env
        mix += equal_power_pan(voice, pan)


def formant_weight(frequency: float) -> float:
    # A dark, wordless "o"-like color rather than an identifiable human choir.
    formants = ((420.0, 170.0, 1.0), (920.0, 240.0, 0.42), (2_300.0, 500.0, 0.10))
    return sum(level * np.exp(-0.5 * ((frequency - center) / width) ** 2) for center, width, level in formants)


def add_vocal_haze(t: np.ndarray, mix: np.ndarray, rng: np.random.Generator) -> None:
    env = window(t, 1.0, 10.4, 2.8, 2.8)
    for voice_index, (fundamental, pan) in enumerate(((146.832, -0.22), (220.0, 0.24))):
        voice = np.zeros_like(t)
        for harmonic in range(1, 18):
            frequency = fundamental * harmonic
            if frequency > 4_000:
                break
            amplitude = formant_weight(frequency) / (harmonic ** 0.65)
            phase = rng.uniform(0.0, 2.0 * np.pi)
            vibrato = 0.002 * np.sin(2.0 * np.pi * (0.19 + 0.03 * voice_index) * t + phase)
            voice += amplitude * np.sin(2.0 * np.pi * frequency * t + vibrato + phase)
        peak = np.max(np.abs(voice)) or 1.0
        voice = 0.038 * voice / peak * env
        mix += equal_power_pan(voice, pan)


def pluck(
    t: np.ndarray,
    start: float,
    frequency: float,
    level: float,
    pan: float,
    rng: np.random.Generator,
) -> np.ndarray:
    local = t - start
    active = local >= 0.0
    tone = np.zeros_like(t)
    duration = 3.0
    active &= local <= duration

    for harmonic in range(1, 10):
        decay = np.exp(-local[active] * (1.35 + harmonic * 0.21))
        phase = rng.uniform(0.0, 2.0 * np.pi)
        slight_stretch = 1.0 + 0.0007 * harmonic * harmonic
        tone[active] += (
            np.sin(2.0 * np.pi * frequency * harmonic * slight_stretch * local[active] + phase)
            * decay
            / (harmonic ** 1.22)
        )

    attack = np.zeros_like(t)
    attack_active = (local >= 0.0) & (local < 0.055)
    attack[attack_active] = rng.normal(0.0, 1.0, np.count_nonzero(attack_active))
    attack[attack_active] *= np.exp(-local[attack_active] * 65.0)
    tone += 0.12 * attack
    tone *= level
    return equal_power_pan(tone, pan)


def add_lyre_motif(t: np.ndarray, mix: np.ndarray, rng: np.random.Generator) -> None:
    # D-minor / Dorian fragments: open fifths and unresolved modal motion.
    notes = (
        (1.25, 220.000, 0.105, -0.38),  # A3
        (2.35, 293.665, 0.120, 0.26),   # D4
        (3.72, 349.228, 0.075, -0.12),  # F4
        (5.05, 391.995, 0.082, 0.34),   # G4
        (6.55, 293.665, 0.098, -0.28),  # D4
        (8.15, 261.626, 0.078, 0.18),   # C4
        (9.28, 220.000, 0.070, -0.18),  # A3
        (10.10, 293.665, 0.062, 0.12),  # D4
    )
    for start, frequency, level, pan in notes:
        mix += pluck(t, start, frequency, level, pan, rng)


def add_gate_resonances(t: np.ndarray, mix: np.ndarray) -> None:
    for hit_index, start in enumerate((3.95, 7.05, 9.55)):
        local = t - start
        active = (local >= 0.0) & (local <= 3.0)
        tone = np.zeros_like(t)
        for mode_index, ratio in enumerate((1.0, 1.607, 2.491, 3.934, 6.18)):
            frequency = 82.407 * ratio
            decay = np.exp(-local[active] * (0.72 + mode_index * 0.18))
            tone[active] += (
                np.sin(2.0 * np.pi * frequency * local[active] + mode_index * 0.7)
                * decay
                / (1.0 + mode_index * 0.75)
            )
        level = (0.050, 0.065, 0.042)[hit_index]
        mix += equal_power_pan(level * tone, (-0.45, 0.42, -0.08)[hit_index])


def add_horn_swell(t: np.ndarray, mix: np.ndarray) -> None:
    start = 6.15
    local = t - start
    env = window(t, start, 4.6, 1.4, 1.6)
    horn = np.zeros_like(t)
    fundamental = 73.416
    vibrato = 0.004 * np.sin(2.0 * np.pi * 0.41 * local)
    for harmonic in range(1, 9):
        amplitude = np.exp(-0.36 * harmonic) / (harmonic ** 0.28)
        horn += amplitude * np.sin(
            2.0 * np.pi * fundamental * harmonic * local + vibrato * harmonic + harmonic * 0.3
        )
    horn *= 0.105 * env
    mix += equal_power_pan(horn, 0.05)


def add_bifrost_shimmer(t: np.ndarray, mix: np.ndarray, rng: np.random.Generator) -> None:
    env = window(t, 6.7, 4.4, 1.5, 1.25)
    for layer in range(7):
        base = 620.0 + layer * 147.0
        rate = 9.0 + layer * 2.4
        phase = rng.uniform(0.0, 2.0 * np.pi)
        chirp_phase = 2.0 * np.pi * (base * t + 0.5 * rate * (t - 6.7) ** 2)
        flutter = 0.72 + 0.28 * np.sin(2.0 * np.pi * (0.13 + layer * 0.017) * t + phase)
        shimmer = 0.010 * env * flutter * np.sin(chirp_phase + phase)
        mix += equal_power_pan(shimmer, -0.8 + layer * (1.6 / 6.0))


def add_space_noise(t: np.ndarray, mix: np.ndarray, rng: np.random.Generator) -> None:
    count = t.size
    for channel in range(2):
        white = rng.normal(0.0, 1.0, count)
        kernel = np.ones(96) / 96.0
        low = np.convolve(white, kernel, mode="same")
        cold_hiss = white - low
        slow_points = rng.uniform(0.35, 1.0, 80)
        slow = np.interp(np.arange(count), np.linspace(0, count - 1, slow_points.size), slow_points)
        mix[:, channel] += 0.0065 * cold_hiss * slow * window(t, 0.0, DURATION, 1.2, 1.5)


def render(output: Path) -> None:
    rng = np.random.default_rng(1643)
    frame_count = int(SAMPLE_RATE * DURATION)
    t = np.arange(frame_count, dtype=np.float64) / SAMPLE_RATE
    mix = np.zeros((frame_count, 2), dtype=np.float64)

    add_drone(t, mix)
    add_vocal_haze(t, mix, rng)
    add_lyre_motif(t, mix, rng)
    add_gate_resonances(t, mix)
    add_horn_swell(t, mix)
    add_bifrost_shimmer(t, mix, rng)
    add_space_noise(t, mix, rng)

    # Gentle glue and a safe master peak.
    mix = np.tanh(mix * 1.35)
    peak = np.max(np.abs(mix)) or 1.0
    mix = 0.92 * mix / peak
    pcm = np.asarray(np.round(mix * 32_767.0), dtype="<i2")

    output.parent.mkdir(parents=True, exist_ok=True)
    with wave.open(str(output), "wb") as wav:
        wav.setnchannels(2)
        wav.setsampwidth(2)
        wav.setframerate(SAMPLE_RATE)
        wav.writeframes(pcm.tobytes())


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    render(args.output)


if __name__ == "__main__":
    main()
