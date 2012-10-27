---
layout: post
title: Using EasyMock to unit test Tapestry components and pages
tags:
- en
- Software-Development
status: publish
type: post
published: true
meta:
  _wpas_done_twitter: '1'
  delicious: a:3:{s:5:"count";s:1:"0";s:9:"post_tags";s:0:"";s:4:"time";s:10:"1265158919";}
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1265158922";}
  _edit_last: '6384953'
---
Currently I'm working on a client project where we use <a href="http://tapestry.apache.org">Tapestry 5.1</a> as our web framework. We want to test well so we are using Tapestry's PageTester to write unit tests for pages and components. If you do that, you'll quickly run into the issue of how to inject services into your pages and components without creating an application module in each and every test class.

A while back Russell Brown posted on the Tapestry mailing list a description of a simple solution to this. In November Russell and I emailed and he was kind enough to share his solution on <a href="http://gist.github.com/227866">gist.github.com</a>.

This is an example of how I use it in a unit test for a component:

<pre class="codeSample">
public class ProductsInCategoryDisplayTest {

  @Mock
  private CategoryRepository categoryRepository ;

  @Test
  public void getProductsForCategory() {
    ProductsInCategoryDisplay display = new ProductsInCategoryDisplay() ;
    
    Category selectedCategory = new Category(1, "Category", "SEO Text for Category") ;
    EasyMockHelper helper = new EasyMockHelper(this, display) ;
    EasyMock.expect(categoryRepository.getCategoryProducts(selectedCategory, true, null)).andStubReturn(new ArrayList()) ;
    helper.replayMocks() ;

    display.setCategory(selectedCategory) ;
    
    Collection products = display.getProducts() ;
    assertNotNull(products) ;
  }

}
</pre>

The <code>@Mock</code> annotation marks <code>CategoryRepository</code> as something that should be mocked and injected. <code>new EasyMockHelper(this, display)</code> lets the helper know that it should look for mocks in the test class and that <code>display</code> is the place where to inject them into.

The rest is regular setting of expectations for EasyMock. Finally the helper gets told to replay the mocks and the it all works.
