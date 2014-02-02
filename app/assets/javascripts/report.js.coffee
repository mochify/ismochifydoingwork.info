# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

MochiReport = window.MochiReport || {};


toggleLoadIndicator = (selector) ->
  loader = selector + " .loader";
  content = selector + " .loaded-content";
  jQuery(loader).hide();
  jQuery(content).show();

recentCommitChart = (selector, data) -> 
  # elementWidth/Height are the W/H of the entire chart element, including axes/labels, etc.  chartWidth/Height denote
  # the space available to display the actual data itself.
  chartMargin = {top: 0, right: 50, bottom: 40, left: 0}
  elementWidth = 850
  elementHeight = 450
  chartWidth = elementWidth - (chartMargin.left + chartMargin.right);
  chartHeight = elementHeight - (chartMargin.top + chartMargin.bottom);


  barWidth = chartWidth / data.length;
  xLabels = _.range(1, data.length + 1).reverse();

  xScale = d3.scale.ordinal()
    .domain(xLabels)
    .rangeBands([0, chartWidth]);
  yScale = d3.scale.linear().range([chartHeight, 0]).domain([0, d3.max(data)]);
  xAxis = d3.svg.axis()
    .scale(xScale)
    .orient("bottom");
  yAxis = d3.svg.axis()
    .scale(yScale)
    .orient("right")
    .ticks(5);


  chart = d3.select(selector)
    .attr("width", elementWidth).attr("height", elementHeight)
    .attr("transform", "translate(" + chartMargin.left + "," + chartMargin.top + ")");

  chart.append("g")
    .attr("class", "axis x")
    .attr("transform", "translate(0," + chartHeight + ")")
    .call(xAxis)
    .append("text")
    .attr("style", "text-anchor: middle")
    .attr("x", chartWidth / 2)
    .attr("y", 30)
    .text("# Weeks Ago");

  chart.append("g")
    .attr("class", "axis y")
    .attr("transform", "translate(" + chartWidth + ",0)")
    .call(yAxis)
    .append("text")
    .attr("transform", "rotate(90)")
    .attr("style", "text-anchor: middle")
    .attr("x", chartHeight / 2)
    .attr("y", -40)
    .text("# Commits");


  bars = chart.selectAll("g .bar")
    .data(data)
      .enter().append("g")
    .attr("transform", (d, i) -> "translate(" + i * barWidth + ",0)");

  # The +/-i offsets seem a bit hacky, probably a better way to do this.
  bars.append("rect")
    .attr("y", (d) -> yScale(d))
    .attr("width", (d) -> barWidth - 2)
    .attr("height", (d) -> chartHeight - yScale(d));

  bars.append("text")
    .attr("class", "bar-label")
    .attr("x", (d) -> (barWidth / 2))
    .attr("y", (d) -> d3.min([yScale(d), chartHeight - 15]))
    .attr("dy", "1em").text((d) -> d);


jQuery.extend(MochiReport, {
    recentCommitChart: recentCommitChart,
    toggleLoadIndicator: toggleLoadIndicator
});

# Other libs seem to have a lot of stuff with typeof in case it's used in a module context vs in a browser or whatnot,
# but not necessary for now I guess.  Just expose to the global namespace.
window.MochiReport = MochiReport;
