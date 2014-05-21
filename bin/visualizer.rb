#!/usr/bin/env ruby
require 'bundler/setup'
require 'cairo'
require 'pry'
require 'gnuplot'

$LOAD_PATH.unshift "lib"
$LOAD_PATH.unshift "../lib"

$stdout.puts "Movement Visualizer / Oto Brglez - otobrglez@gmail.com"

require 'tcx_file'

# Dir.glob(File.join(ENV["INPUT_FOLDER"],"*.tcx"))[0..10].each_with_index do |file,i|
Dir.glob(File.join(ENV["INPUT_FOLDER"],"*.tcx")).each_with_index do |file,i|

  tcx_file = TCXFile.new(file)

  minlat = tcx_file.geo_information[0][0]
  maxlat = tcx_file.geo_information[2][0]
  minlon = tcx_file.geo_information[0][1]
  maxlon = tcx_file.geo_information[3][1]

  x = tcx_file.points.map(&:first)
  y = tcx_file.points.map(&:last)

  Gnuplot.open do |gp|
    Gnuplot::Plot.new(gp) do |plot|
      plot.terminal "png size 2000, 2000"
      #set terminal png size 320,240

      plot.output "./build/#{i}.png"

      plot.arbitrary_lines << "unset tics"
      plot.arbitrary_lines << "unset border"

      plot.arbitrary_lines << "set grid"

      plot.arbitrary_lines << "set term png transparent truecolor"
      plot.arbitrary_lines << "set size square"
      plot.arbitrary_lines << "set xrange [#{minlat}:#{maxlat}]"
      plot.arbitrary_lines << "set yrange [#{minlon}:#{maxlon}]"

      plot.arbitrary_lines << "set linetype 1 linecolor rgb '#000000' linewidth 20"
      # plot.arbitrary_lines << "set samples 100"

      plot.data << Gnuplot::DataSet.new([x, y]) do |ds|
        ds.with = "lines"
        ds.notitle
      end

    end
  end

end

$stdout.puts "Done"
