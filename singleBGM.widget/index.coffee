command: "last=$(python -c 'import urllib, json, sys; print(json.loads(urllib.urlopen(\"YOURURL/pebble\").read()))') && curl --silent YOURURL/pebble"

# Set the refresh frequency (milliseconds) to every minute
refreshFrequency: 60*1000
myNamez
style: """

  widget-align = left			// Align contents left or right
  top: 10px				// Position widget
  left: 10px
  color: #fff				// Text settings
  font-family Helvetica Neue
  background rgba(#000, .5)
  padding 20px 20px 20px 20px
  border-radius 5px

  #container				// Settings for widget container
    text-align: widget-align
    position: relative
    clear: both

  #data-title
    font-size 50px
    text-transform uppercase
    font-weight bold

  #data-name
    font-size 20px

  #data-info
    font-size 20px
    text-align justify
"""
# Render the output.
render: (output) -> """
  <div id='container'>
  <div>
"""


update: (output, domEl) -> 
  try
    data = JSON.parse(output)
    myDelta = data.bgs[0].bgdelta
    myName = "PUT YOUR NAME HERE"
    if myDelta.charAt(0) != "-" and not myDelta.startsWith("0.0") 
      myDelta = "+" + myDelta
    
    switch(data.bgs[0].direction) 
      when 'NONE' then myDirection =  '⇼';
      when 'DoubleUp' then myDirection =  '⇈';
      when 'SingleUp' then myDirection =  '↑';          
      when 'FortyFiveUp' then myDirection =  '↗';                  
      when 'Flat' then myDirection =  '→';                      
      when 'FortyFiveDown' then myDirection =  '↘';
      when 'SingleDown' then myDirection =  '↓';  
      when 'DoubleDown' then myDirection =  '⇊';
      when 'NOT COMPUTABLE' then myDirection =  '-';  
      when 'RATE OUT OF RANGE' then myDirection =  '⇕';
      else '⇼';

    myDate = new Date(data.bgs[0].datetime)
    updateTime = myDate.toLocaleTimeString('en-US', { hour: "numeric", minute: "numeric" })
    MIN = 1000 * 60 
    currentTime = new Date()
    min_passed = Math.round((currentTime.getTime() - myDate.getTime()) / MIN)
    minStr = "min"
    if min_passed > 1
      minStr = "mins"
    container = $(domEl).find('#container')
    content = 
      """
	  <div id="data-name">#{myName} BGM - #{min_passed} #{minStr} ago at #{updateTime} </div>
    <div id="data-title">#{data.bgs[0].sgv} #{myDirection} (#{myDelta})</div>

      """
    $(container).html content
  catch e
    # do nothing


