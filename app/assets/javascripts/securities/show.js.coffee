$ ->
  $.get window.closingPriceUrl,
    (data) ->
      processClosingProces(data)




processClosingProces = (prices) ->
  options =
    yaxis: {},
    xaxis:
      mode: "time",
      timeformat: "%y-%m-%d",
    colors: ["#F90", "#222", "#666", "#BBB"],
    hoverable: true
    series:
      lines:
        lineWidth: 2,
        fill: true,
        fillColor: { colors: [ { opacity: 0.6 }, { opacity: 0.2 } ] },
        steps: false
  plotData = []
  for price in prices
    plotData.push [Date.parse(price.date), price.price]

  $.plot($('#security-historical-chart'), [plotData], options)
  previousPoint = null
  $("#placeholder").bind "plothover", (event, pos, item) ->
    $("#x").text pos.x.toFixed(2)
    $("#y").text pos.y.toFixed(2)
    if item
      unless previousPoint is item.dataIndex
        previousPoint = item.dataIndex
        $("#tooltip").remove()
        x = item.datapoint[0].toFixed(2)
        y = item.datapoint[1].toFixed(2)
        showTooltip item.pageX, item.pageY, y
    else
      $("#tooltip").remove()
      previousPoint = null