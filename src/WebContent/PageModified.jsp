<%-- 
    JSPWiki - a JSP-based WikiWiki clone.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.  
--%>
<%@ page import="org.apache.wiki.log.Logger" %>
<%@ page import="org.apache.wiki.log.LoggerFactory" %>
<%@ page import="org.apache.commons.lang.*" %>
<%@ page import="org.apache.wiki.*" %>
<%@ page import="org.apache.wiki.ui.EditorManager" %>
<%@ page errorPage="/Error.jsp" %>
<%@ taglib uri="http://jakarta.apache.org/jspwiki.tld" prefix="wiki" %>
<%@ taglib uri="http://stripes.sourceforge.net/stripes.tld" prefix="stripes" %>
<%@ page import="org.apache.wiki.util.TextUtil" %>
<stripes:useActionBean beanclass="org.apache.wiki.action.PageModifiedActionBean" event="conflict" id="wikiActionBean" />

<%! 
    Logger log = LoggerFactory.getLogger("JSPWiki");
%>

<%
    WikiEngine wiki = WikiEngine.getInstance( getServletConfig() );
    // Create wiki context and check for authorization
    WikiContext wikiContext = wiki.createContext( request, WikiContext.CONFLICT );
    String pagereq = wikiContext.getPage().getName();

    String usertext = (String)session.getAttribute( EditorManager.REQ_EDITEDTEXT );

    // Make the user and conflicting text presentable for display.
    usertext = StringEscapeUtils.escapeXml( usertext );
    usertext = TextUtil.replaceString( usertext, "\n", "<br />" );

    String conflicttext = wiki.getText(pagereq);
    conflicttext = StringEscapeUtils.escapeXml( conflicttext );
    conflicttext = TextUtil.replaceString( conflicttext, "\n", "<br />" );

    pageContext.setAttribute( "conflicttext",
                              conflicttext,
                              PageContext.REQUEST_SCOPE );

    log.info("Page concurrently modified "+pagereq);
    pageContext.setAttribute( "usertext",
                              usertext,
                              PageContext.REQUEST_SCOPE );

    // Set the content type and include the response content
    response.setContentType("text/html; charset="+wiki.getContentEncoding() );
    String contentPage = wiki.getTemplateManager().findJSP( pageContext,
                                                            wikiContext.getTemplate(),
                                                            "ViewTemplate.jsp" );
%><wiki:Include page="<%=contentPage%>" />

