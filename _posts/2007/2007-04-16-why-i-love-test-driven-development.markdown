---
layout: post
title: Why I love test-driven development
tags:
- en
categories:
- software_development
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
---
<p>Here is a very good example why I am a big fan of TDD (test-driven development). Instead of writing a specification or a requirements document I wrote the following test case and let Eclipse create a few new classes for me. Then I wrote enough code to get the basic functionality right and added a mock UserService with a few expectation set.</p>

<pre class="codeSample">public class EnrollmentTest extends TestCase {
  public void testSignupTrialWithoutPayingOrganization() throws UserNotFoundException {
    PaymentDetails paymentDetails = new CreditCardDetails() ;

    Person firstPerson = new Person() ;
    firstPerson.setRfc822Address("sns@caimito.net") ;

    Person secondPerson = new Person() ;
    secondPerson.setRfc822Address("fidel@caimito.net") ;

    UserService userService = EasyMock.createMock(UserService.class) ;
    EasyMock.expect(userService.findUser(firstPerson.getRfc822Address())).andThrow(new UserNotFoundException()) ;
    userService.saveUser(new User(firstPerson.getRfc822Address())) ;
    EasyMock.expect(userService.findUser(secondPerson.getRfc822Address())).andThrow(new UserNotFoundException()) ;
    userService.saveUser(new User(secondPerson.getRfc822Address())) ;
    EasyMock.replay(userService) ;
		
    SignupManager signupManager = new PerUserSignupManager() ;
    signupManager.setUserService(userService) ;

    try {
      Customer customer = signupManager.signup(firstPerson, paymentDetails) ;
      User firstUser = customer.createUserAccount(firstPerson) ;
      assertNotNull(firstUser) ;
      assertEquals(firstPerson.getRfc822Address(), firstUser.getUsername()) ;
			
      User secondUser = customer.createUserAccount(secondPerson) ;
      assertNotNull(secondUser) ;
      assertEquals(secondPerson.getRfc822Address(), secondPerson.getUsername()) ;
    } catch (SignupFailedException e) {
      fail(e.getMessage()) ;
    } catch (UserAlreadyExistsException e) {
      fail(e.getMessage()) ;
    }
  }
}</pre>

<p>This test case is very high-level. There is more to be implemented. The work of implementing the details can be distributed amongst the members of a team. That way everybody gets involved a bit, which is good to foster shared ownership of the code base, and it allows to delegate some easier tasks to Junior Developers. </p>

<p>Such a high-level test case can be used as well by a Senior Developer with more design experience to more precisely prepare a task for a learner. The high-level design is there and the Junior Developer can fill in the missing pieces and design a bit of the lower level parts. He will be able to learn good design and contribute working code to the project.</p>
