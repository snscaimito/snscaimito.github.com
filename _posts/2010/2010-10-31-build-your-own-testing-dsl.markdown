---
layout: post
title: Build your own testing DSL
tags:
- en
categories:
- software_development
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
  jabber_published: '1288538832'
  _wp_old_slug: ''
  _wpas_mess: ! 'Build your own testing DSL: http://wp.me/pKfoa-ad'
  _wpas_done_twitter: '1'
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1299658822";}
---
Since Friday the <a href="http://sdtconf.com">Simple Design and Testing</a> conference is in full swing in Columbus, Ohio. I missed the opening on Friday and will be missing today, as I'm currently waiting at the airport for my flight. But I was able to attend this very interesting open space conference on Saturday.

This morning before I left my hotel I read on Twitter <a href="http://twitter.com/#!/search/%23sdtconf">#sdtconf</a> that today they plan to do some exercise in test-driven development in Java without using JUnit or any other tool. Now that I'm sitting here at the airport and am waiting for my 1 pm flight I thought I can try that myself for a while.

So here is my very first attempt at this.

First I created my test class where I intent to verify the behavior of the ExperimentalService class.

```java
public class ExperimentalTest {

	public void something() {		
		ExperimentalService service = new ExperimentalService() ;
		
		verify(service.someMethod()).shouldBe("Green") ;
	}
}
```

As you can see I want to use a DSL where the verify() statement allows me to check behavior using shouldBe(). So here I am verifying that service.someMethod() returns the string value "Green".

Next I created the ExperimentalService class.

```java
public class ExperimentalService {

	public String someMethod() {
		return null;
	}

}
```

someMethod() returns null for the moment. Let's pretend that I don't know yet how to implement this method. We want to get to a failing test before writing any production code.

Now it is time to start working on the testing framework. Here is the first draft of the verify() method:

```java
public class Verifier {

	public static Should verify(Object obj) {
		return new Should(obj) ;
	}
	
}
```

Now with the verify() method implemented I can do a static import of Verifier.* in my test case: <code>import static org.experiment.Verifier.*</code>

As you can see the verify() method returns an Object of class Should. Here is the draft for that:

```java
public class Should {

	private Object valueToBeInspected ;
	
	public Should(Object valueToBeInspected) {
		this.valueToBeInspected = valueToBeInspected ;
	}
	
	public void shouldBe(Object expected) {
		if (!expected.equals(valueToBeInspected))
			throw new RuntimeException("Expected " + expected + " but got " + valueToBeInspected) ;
	}

}
```

So if the object expected is not equal to the object valueToBeInspected, then shouldBe() will throw an exception and make the test fail. If they are equal, all is fine and nothing happens: the test passes.

With that in place I can run my test class and because I'm returning null from the something() method I will get this stack trace:

```java
Exception in thread "main" java.lang.RuntimeException: Expected Green but got null
	at org.experiment.Should.shouldBe(Should.java:13)
	at org.experiment.ExperimentalTest.something(ExperimentalTest.java:10)
	at org.experiment.ExperimentalTest.main(ExperimentalTest.java:16)
```

If I now make the test pass by returning "Green", I get the 

```java
Tests run successfully
```

message and can start working on the next behavior.

Greetings to everyone at the <a href="http://sdtconf.com">Simple Design and Testing</a> conference!
