{HTML} = require "nice"
beautify = require "./beautify-html"

mixin = (destination,objects...) ->
  for object in objects
    destination[k] = v for k, v of object
  destination

# bootstrap mixins
Boostrap = 
  
  navbar: (options) ->
    classes = ["navbar"]
    classes.push "navbar-inverse" if options.inverse?
    classes.push "navbar-fixed-top" if options.fixed_top?
    @html.div
      class: classes.join(" ")
      content: @html.div 
        class: "navbar-inner"
        content: @container options.content

  brand: (name) ->
    @html.a
      href: "/"
      class: "brand"
      content: name
  
  navmenu: (items) ->
    @html.ul
      class: "nav"
      content: for item in items
        @html.li
          class: ("active" if item.active?)
          content: @html.a
            href: item.url
            content: item.text

  container: (items) ->
    @html.div
      class: "container"
      content: items
    
  hero: (items) ->
    @html.div
      class: "hero-unit"
      content: items
      
  row: (items) ->
    @html.div
      class: "row"
      content: items
  
  column: (width,items) ->
    @html.div
      class: "span#{width}"
      content: items
      
  button: (options) ->
    classes = [ "btn" ]
    classes.push "btn-primary" if options.primary?
    classes.push "btn-large" if options.large?
    @html.a
      href: options.url
      text: options.text
      class: classes.join(" ")

class Page
  
  constructor: -> 
    @html = new HTML
    mixin(@,Boostrap)
  
  page: ->
    learn_more = "Learn More &raquo;"
    @doctype() + @html.html [
    
      @html.head [
        @meta()
        @javascript()
        @css()
      ]
    
      @html.body [
    
        @navbar
          inverse: true
          fixed_top: true
          content: [
            @brand "BurstPort"
            @navmenu [
              { url: "/", text: "Home", active: true }
              { url: "/about", text: "About"}
            ]
          ]
          
        @container [

          @hero [
            @html.h1 "BurstPort"
            @html.p "Get to market quickly without sacrificing features or incurring technical debt.
                     We provide architecture and development consulting for building applications and
                     services using a proven, pre-integrated platform. " 
            @html.p @button
              primary: true
              large: true
              text: learn_more
              url: "/learn" ]
          
          @row [
            
            @column 4, [
              @html.h2 "Responsive and Extensible Apps"
              @html.p "Our Patchboard technology makes it easy to build sophiticated hypermedia APIs,
                       complete with client libraries that make them a snap to use. And our worker-based
                       architectural approach allows you to build highly responsive, secure apps because
                       you never have to re-establish connections between clients and servers." 
              @html.p @button { primary: true, url: "/responsiveness", text: learn_more } ]
            
            @column 4, [
              @html.h2 "Elastic, Cloud-Friendly Architecture"
              @html.p "With our highly efficient dispatchers and Redis-based messaging transport, you
                       can scale by simply adding workers where you have bottlenecks. Elasticity can
                       be achieved merely by monitoring task queues and allocating more workers. And our
                       cloud-based load testing tools make it easy to verify that your app can handle load."
              @html.p @button { primary: true, url: "/elasticity", text: learn_more } ]
            
            @column 4, [
              @html.h2 "Simple, Rapid Development"
              @html.p "We believe in keeping things simple wherever we can. We use CoffeeScript for most
                       custom development, which combines the familiarity of Javascript with the 
                       expressiveness of Ruby, across both client and server. We use node-fibers to
                       manage the 'callback-spaghetti' often associated with Node-based servers. We handle
                       storage in MongoDB, which makes it easy to get up and running quickly without
                       sacrificing features (indexing, queries) or elasticity (via clustering)." 
              @html.p @button { primary: true, url: "/simplicity", text: learn_more } ]]
              
      
          @html.hr()
          @html.footer @html.p "Copyright &copy; 2012, Daniel Yoder" ]]]
      
  doctype: -> "<!DOCTYPE html>" 
  
  meta: -> ""
  
  javascript: ->
    (for file in @javascript_files()
      @html.script
        src: file
        type: "text/javascript"
        content: "").join ""
        
  css: ->
    (for file in @css_files()
      @html.link
        href: file
        type: "text/css"
        rel: "stylesheet").join ""
        
  javascript_files: ->
    @_javascript_files ?= [
      "http://cdnjs.cloudflare.com/ajax/libs/jquery/1.7.2/jquery.min.js"
      "http://cdnjs.cloudflare.com/ajax/libs/json2/20110223/json2.js"
      "js/bootstrap.min.js"
      "js/application.js"
    ]

  css_files: ->
    @_css_files ?= [
      "css/bootstrap.min.css"
      "css/application.css"
    ]
        
page = new Page

console.log beautify page.page()
    