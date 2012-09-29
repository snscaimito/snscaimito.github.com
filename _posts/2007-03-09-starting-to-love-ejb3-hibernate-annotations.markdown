---
layout: post
title: Starting to love EJB3 Hibernate Annotations
tags:
- Software-Development
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
---
<p>As our current project allows for some experimentation and adoption of recent technologies, we spent today with EJB3 Hibernate Annotations to get away from the XML configuration one used to create with Hibernate before.</p>

<p>The annotations need to be placed in the same compilation unit as the entity class lives in. The result is that these POJOs now are no longer POJOs in a very tight sense. That has been <a href="http://www.theserverside.com/discussions/thread.tss?thread_id=42447">criticized</a> as polluting the codebase with ORM specific annotations. That's certainly right, but one does not replace one ORM tool for another very often and going with the EJB3 Java Persistence annotation one can replace ORM tools, as Hibernate is just one implementation of that API. So I wouldn't fear too much. After all those classes that become entity classes are meant to be stored into a database and somewhere I have to put the mapping. Doing so in Java code instead of an external XML file appears to be clearer and more appealing to a developer.</p>

<p>Here is something we learned today.</p>

<p>Let's define a persistent entity class called <code>Issue</code>.</p>

<pre class="codeSample">@Entity
@Table(name="issue")
@NamedQueries( { @NamedQuery(name = "findIssueById", query = "from Issue i where i.id = ?") })
public class Issue implements IdentifiableObject {

  @Id @GeneratedValue
  private long id ;

[...]
}</pre>

<p>This entity will be persisted into the table <code>issue</code> and you see that it has an id field. Other fields are omitted for clarity. Further we define a named query <code>findIssueById</code>.</p>

<p>In a generic DAO class using Spring's Hibernate template we create a method <code>findById</code> as follows.</p>

<pre class="codeSample">public Object findById(String query, long id) {
  List list = getHibernateTemplate().findByNamedQuery(query, id);
  if (list.isEmpty())
    return null ;
  else
    return list.get(0) ;
}</pre>

<p>Elsewhere in the application we can the find any entity by calling findById passing in the name of the named query and of course the query criteria id.</p>

<pre class="codeSample">Issue issueRead = (Issue) repository.findById("findIssueById", someId) ;</pre>

<p>In your Spring application context configure your session factory using the <code>AnnotationSessionFactoryBean</code>.</p>

<pre class="codeSample">
  
  
    
      org.hibernate.dialect.HSQLDialect
      [...]
    
  
  
    
      net.caimito.savila.Issue
    
  
</pre>

