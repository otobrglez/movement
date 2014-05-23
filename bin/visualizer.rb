#!/usr/bin/env ruby
require 'bundler/setup'
require 'cairo'
require 'pry'
require 'gnuplot'

ENV["INPUT_FOLDER"] ||= "tmp"
ENV["IMG_SIZE"] ||= "1000"
ENV["NUM_OF_FRAMES"] = ENV["NUM_OF_FRAMES"] ||= "360"

$LOAD_PATH.unshift "lib"
$LOAD_PATH.unshift "../lib"

$stdout.puts "Movement Visualizer / Oto Brglez - otobrglez@gmail.com"

require 'tcx_file'

files = Dir.glob(File.join(ENV["INPUT_FOLDER"],"*.tcx"))
files = files[0..(ENV["NUM_OF_FILES"].to_i)] unless ENV["NUM_OF_FILES"].nil?

files.each_with_index do |file,i|
  $stdout.puts "Processing: #{file}"
  tcx_file = TCXFile.new(file)

  minlat = tcx_file.geo_information[0][0]
  maxlat = tcx_file.geo_information[2][0]
  minlon = tcx_file.geo_information[0][1]
  maxlon = tcx_file.geo_information[3][1]

  x = tcx_file.points.map(&:first)
  y = tcx_file.points.map {|p| p[1]}
  z = tcx_file.points.map {|p| p[2]}

  zmin = z.min
  zmax = z.max

  (0..(ENV["NUM_OF_FRAMES"].to_i)).to_a.each do |frame|
    angle = frame

    Gnuplot.open do |gp|
      Gnuplot::SPlot.new(gp) do |plot|
        plot.terminal "png size #{ENV['IMG_SIZE']}, #{ENV['IMG_SIZE']}"

        plot.output "./build/frame-#{i}-%03d.png" % frame
        plot.arbitrary_lines << "unset tics"
        plot.arbitrary_lines << "unset border"
        plot.arbitrary_lines << "set grid"

        plot.arbitrary_lines << "set term png transparent truecolor" # transparent
        plot.arbitrary_lines << "set size square"

        # plot.arbitrary_lines << "set ztics 1"

        plot.arbitrary_lines << "set xrange [#{minlat}:#{maxlat}]"
        plot.arbitrary_lines << "set yrange [#{minlon}:#{maxlon}]"
        plot.arbitrary_lines << "set zrange [#{zmin}:#{zmax}]" ##{zmax}

        #plot.arbitrary_lines << "set linetype 1 linecolor rgb '#000000' linewidth 5"
        plot.arbitrary_lines << "set linetype 1 linecolor palette linewidth 3"

        plot.arbitrary_lines << 'set palette defined ( 0 "#0FA9ED", 6 "#E23452")'
        # plot.arbitrary_lines << "set palette rgbformulae 3,11,6"

        plot.arbitrary_lines << "unset key"
        plot.arbitrary_lines << "unset colorbox"

        plot.arbitrary_lines << "set view 45, #{angle}"

        plot.data << Gnuplot::DataSet.new([x, y, z]) do |ds|
          #ds.smooth = "sbezier"
          #ds.with = "lines" # "linespoints" # "points" # "lines"
          ds.with = "boxes" # <- hudo
          ds.notitle
        end
      end
    end
  end

end

$stdout.puts "Done"
