require 'nokogiri'

class TCXFile

  attr_accessor :sport, :distance, :geo_information, :points, :altitudes

  def initialize path
    self.points = []
    self.geo_information = [
      [0,0], # top left
      [0,0], # top right
      [0,0], # bottom left
      [0,0]  # bottom right
    ]

    self.altitudes = [
      0, # Min
      0, # Max
    ]

    self.distance = 0

    file = File.open path
    parse file
    file.close
  end

  def parse file
    doc = Nokogiri::XML(file)
    doc.remove_namespaces!

    doc.xpath('//Activity').each do |a|
      self.sport = a.attributes["Sport"].value rescue nil
      self.distance = a.xpath("//DistanceMeters").first.content.to_f rescue 0
    end

    is_set = false
    doc.xpath('//Trackpoint').each do |p|
      begin
        la = p.xpath('Position/LatitudeDegrees').first.content.to_f
        lo = p.xpath('Position/LongitudeDegrees').first.content.to_f
      rescue
        la, lo = nil, nil
      end

      begin
        altitude = Float(p.xpath("AltitudeMeters").first.content.to_s)
      rescue
        altitude = nil
      end

      next if la.nil? or lo.nil? or altitude.nil?

      unless is_set
        self.geo_information[0] = [la, lo]
        self.geo_information[1] = [la, lo]
        self.geo_information[2] = [la, lo]
        self.geo_information[3] = [la, lo]
        self.altitudes = [altitude, altitude] unless altitude.nil?
        is_set = true
      end

      # top left
      self.geo_information[0] = [
        (la < self.geo_information[0][0] ? la : self.geo_information[0][0]),
        (lo < self.geo_information[0][1] ? lo : self.geo_information[0][1]),
      ]

      # top right
      self.geo_information[1] = [
        (la < self.geo_information[1][0] ? la : self.geo_information[1][0]),
        (lo > self.geo_information[1][1] ? lo : self.geo_information[1][1]),
      ]

      # bottom right
      self.geo_information[2] = [
        (la > self.geo_information[2][0] ? la : self.geo_information[2][0]),
        (lo < self.geo_information[2][1] ? lo : self.geo_information[2][1]),
      ]

      # bottom right
      self.geo_information[3] = [
        (la > self.geo_information[3][0] ? la : self.geo_information[3][0]),
        (lo > self.geo_information[3][1] ? lo : self.geo_information[3][1]),
      ]

      self.altitudes = [
        (altitude < self.altitudes[0] ? altitude : self.altitudes[0]),
        (altitude > self.altitudes[1] ? altitude : self.altitudes[1]),
      ] unless altitude.nil?

      self.points.push [la, lo]
    end
  end

  def scale_to_relative! width, height
    geo_width   = self.geo_information[1][1] - self.geo_information[0][1]
    geo_height  = self.geo_information[2][0] - self.geo_information[0][0]

    w_f = geo_width   / width
    h_f = geo_height  / height

    puts [w_f, h_f]
  end


end
