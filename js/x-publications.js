const seriesLayout = document.querySelector("[data-x-publication-masonry]");

if (seriesLayout) {
	const series = Array.from(seriesLayout.children);
	let currentColumnCount = 0;

	const arrangeSeries = () => {
		const minimumColumnWidth = 352;
		const gap = 24;
		const columnCount = Math.min(series.length, Math.max(1, Math.floor((seriesLayout.clientWidth + gap) / (minimumColumnWidth + gap))));
		if (columnCount === currentColumnCount) return;

		currentColumnCount = columnCount;
		seriesLayout.replaceChildren();
		const columns = Array.from({ length: columnCount }, () => {
			const column = document.createElement("div");
			column.className = "x-publications__column";
			seriesLayout.append(column);
			return column;
		});

		series.forEach((seriesGroup) => {
			const shortestColumn = columns.reduce((shortest, column) =>
				column.scrollHeight < shortest.scrollHeight ? column : shortest
			);
			shortestColumn.append(seriesGroup);
		});
	};

	arrangeSeries();
	if ("ResizeObserver" in window) {
		new ResizeObserver(arrangeSeries).observe(seriesLayout);
	} else {
		window.addEventListener("resize", arrangeSeries);
	}
}

document.querySelectorAll("[data-copy-url]").forEach((button) => {
	button.addEventListener("click", async () => {
		const status = document.querySelector(".x-publications__status");
		const url = button.dataset.copyUrl;

		try {
			await navigator.clipboard.writeText(url);
			button.textContent = "Copied";
			button.classList.add("is-copied");
			status.textContent = `Copied ${url}`;
			window.setTimeout(() => {
				button.textContent = "Copy URL";
				button.classList.remove("is-copied");
			}, 1600);
		} catch (_error) {
			status.textContent = "Copy failed. Select the visible URL and copy it manually.";
		}
	});
});
