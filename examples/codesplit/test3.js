

//import * as d3 from "d3";
//import {select as d3.select} from 'd3-selection'
var d3 = require('d3')


function dragstarted(d) {
      d3.select(this).raise().classed("active", true);
}

function dragged(d) {
      d3.select(this).attr("cx", d.x = d3.event.x).attr("cy", d.y = d3.event.y);
}

function dragended(d) {
      d3.select(this).classed("active", false);
}

window.addEventListener('load', function() { 

    var svg = d3.select("svg"),
            width = +svg.attr("width"),
            height = +svg.attr("height"),
            radius = 32;

    var circles = d3.range(20).map(function() {
          return {
                  x: Math.round(Math.random() * (width - radius * 2) + radius),
                  y: Math.round(Math.random() * (height - radius * 2) + radius)
                };
    });

    var color = d3.scaleOrdinal()
        .range(d3.schemeCategory10);

    svg.selectAll("circle")
      .data(circles)
      .enter().append("circle")
        .attr("cx", function(d) { return d.x; })
        .attr("cy", function(d) { return d.y; })
        .attr("r", radius)
        .style("fill", function(d, i) { return color(i); })
        .call(d3.drag()
                    .on("start", dragstarted)
                    .on("drag", dragged)
                    .on("end", dragended));

})
