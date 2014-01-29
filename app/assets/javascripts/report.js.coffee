# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

MochiReport = {};


toggleLoadIndicator = (selector) ->
  loader = selector + " .loader";
  content = selector + " .loaded-content";
  jQuery(loader).hide();
  jQuery(content).show();

recentCommitChart = (selector, data) -> 
  chartWidth = 900;
  chartHeight = 500;

  barWidth = chartWidth / data.length;
  yScale = d3.scale.linear().range([chartHeight, 0]).domain([0, d3.max(data)]);

  chart = d3.select(selector).attr("width", chartWidth).attr("height", chartHeight);

  bars = chart.selectAll("g")
    .data(data)
      .enter().append("g")
    .attr("transform", (d, i) -> "translate(" + i * barWidth + ",0)");

  # The +/-i offsets seem a bit hacky, probably a better way to do this.
  bars.append("rect")
    .attr("y", (d) -> yScale(d))
    .attr("width", (d) -> barWidth - 2)
    .attr("height", (d) -> chartHeight - yScale(d));

  bars.append("text")
    .attr("x", (d) -> (barWidth / 2) + 4)
    .attr("y", (d) -> yScale(d))
    .attr("dy", "1em").text((d) -> d);


MochiReport.recentCommitChart = recentCommitChart;
MochiReport.toggleLoadIndicator = toggleLoadIndicator;

# Other libs seem to have a lot of stuff with typeof in case it's used in a module context vs in a browser or whatnot,
# but not necessary for now I guess.  Just expose to the global namespace.
window.MochiReport = MochiReport;
