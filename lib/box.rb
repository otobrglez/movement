class Box
  # height and width for the rectangle, angle for the rotation
  attr_accessor :height, :width, :angle

  def initialize(height=200, width=200, angle=45)
    @height, @width, @angle = [height, width, degrees_to_radians(angle)]
    # The first argument for a surface is the filename, the next two are our canvas/surface size.
    # I am making the surface twice as big as the object (WxH) we want to create, just to give it some padding.
    @surface = Cairo::SVGSurface.new("rotated_square.svg", @width * 2, @height * 2)
    # setup our context object to draw on
    @cr = Cairo::Context.new(@surface)
    # set it up with rotation
    setup_scene_with_rotation
    # draw the square
    return build_rotated_square
  end

private

  def setup_scene_with_rotation
    # give it a white background
    @cr.set_source_color(:white)
    @cr.paint

    # rotate everything by our angle (in rads) from the middle
    # if you do not move the rotation point to the center, you will be rotating from 0,0 (bottom left of the canvas)
    # so first move to the middle of the surface (coords of W,H, since our canvas is 2W x 2H)
    # then do the rotation
    # then move back to 0,0
    # we know that width, height is the center b/c we start at 0,0
    # see @cr.current_point to be sure
    @cr.translate(@width, @height)
    @cr.rotate(@angle)
    @cr.translate(-@width, -@height)
  end

  def build_rotated_square
    # build a rectangle with height and width dimensions
    # x and y are the starting points from which the rectangle is drawn
    # x and y are the bottom left of the box
    x = @width / 2
    y = @height / 2
    @cr.rectangle(x, y, @width, @height)
    # the object has been created but is invisible, so let's draw a line around it
    # the line will be black
    @cr.set_source_color(:black)
    # apply the line
    @cr.stroke
    # create the SVG
    @cr.target.finish
  end

  # the angle comes in, in the form of the degrees and will need to be converted to radians
  def degrees_to_radians(angle_in_degrees)
    return angle_in_degrees / 180.0 * Math::PI
  end

end

# let's get our box ... I'm not using GTK, so it will just spit out an image in the local fs
