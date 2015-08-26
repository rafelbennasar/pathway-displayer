class window.Compound

  constructor: (@id, @label, @description, @position, @size, @shape, @color) ->
    [@cx, @cy] = [get_m2c_point(@position[0]), get_m2c_point(@position[1])]
    [@cw, @ch] = [get_m2c_point(size[0]), get_m2c_point(size[1])]

    @virtual = @id < 0

    if @shape == "square"
      @cx1 = @cx #- (@cw/2)
      @cy1 = @cy #- (@ch/2)
    [@mw, @mh] = [@size[0], @size[1]]
    [@mx, @my] = [@position[0]+@mw/2, @position[1]+@mh/2]
    @.draw_compound()

    #dot = new paper.Path.Circle([@cx, @cy], 2)
    #dot.fillColor = "black"

  draw_compound: () ->
    if @shape == "circle"
      shape = new paper.Path.Circle(new paper.Point(@cx, @cy), @width)
      shape.fillColor = @color[0];
    else if @shape == "square" #and @id > 0
      if @virtual
        # If it is virtual we have to add the border size!
        shape = new paper.Path.Rectangle(new paper.Point(@cx-(@cw/2), @cy-(@ch/2) + 1), new paper.Size(@cw - 1, @ch));
      else
        shape = new paper.Path.Rectangle(new paper.Point(@cx-(@cw/2), @cy-(@ch/2)), new paper.Size(@cw, @ch));
      shape.fillColor = @color[0];

    if @virtual # Virtual compounds have a gray box with a bit of transparent layer.
      shape.opacity = 0.4
      shape.style = {
                     strokeColor: 'black'
                     fillColor: 'white'
                     strokeWidth: 1 }
    else
      if @cw == @ch  # For the compounds that are "perfectly" square (so, mainly those small compounds xD) we add more padding.
        text = new paper.PointText(new paper.Point(@cx-(@cw/2)+22, @cy-(@ch/2) + 15), new paper.Size(@cw, @ch));
      else
        text = new paper.PointText(new paper.Point(@cx-(@cw/2)+20, @cy-(@ch/2) + 10), new paper.Size(@cw, @ch));
      text.justification = 'center';
      text.fillColor = 'black';
      text.fontSize = '9px'
      text.content = @label # @id


  _get_base_coords: (layout, D) ->
    DX = @mw/2
    DY = @mh/2
    switch layout
      when 1
        p = [@mx, @my - (@mh/2) - D]
      when 2
        p = [@mx + (@mw/2) + D, @my]
      when 3
        p = [@mx, @my + (@mh/2) + D]
      when 4
        p = [@mx - (@mw/2) - D, @my]
    p_aux = [parseInt(p[0]) - DX, parseInt(p[1] - DY)]
    return p_aux




class window.Reaction

  constructor: (@id, @label, @compound1, @compound2, @type) ->
    ##console.log "Building reaction from:", @compound1, @compound2
    @virtual_reactions = []
    @paths = []

  append_virtual_reaction: (obj) ->
    @virtual_reactions.push obj

  append_path: (obj) ->
    @paths.push obj

  get_paths: () ->
    @paths



  @get_coords: (compound1, compound2, map) ->
    B = 1
    [RIGHT, LEFT, DIRECT_RIGHT, DIRECT_LEFT] = [B, B*-1, B*2, B*-2]
    [TOP, BOTTOM, DIRECT_TOP, DIRECT_BOTTOM] = [3*B, B*-3, B*4, B*-4]

    [cmp1, cmp2] = [[compound1.position, compound1.size], [compound2.position, compound2.size]]
    [[p1_x, p1_y], [p1_w, p1_h]] = cmp1
    [[p2_x, p2_y], [p2_w, p2_h]] = cmp2

    reversed = false
    if p1_w < p2_w and p1_h < p2_h
      [compound1, compound2] = [compound2, compound1]
      [cmp1, cmp2] = [[compound1.position, compound1.size], [compound2.position, compound2.size]]
      [[p1_x, p1_y], [p1_w, p1_h]] = cmp1
      [[p2_x, p2_y], [p2_w, p2_h]] = cmp2
      reversed = true


    very_tall = p1_h > 10
    very_long = p1_w > 10
    L1_y = p1_y - p1_h/2
    L2_y = p1_y + p1_h/2
    L1_x = p1_x - p1_w/2
    L2_x = p1_x + p1_w/2

    if p2_y < L1_y
      if p2_x < L1_x
        #console.log "a"
        approach = RIGHT
        pos = [1, 2]
        alt_pos = [4, 3]
        if very_tall
          approach = LEFT
          pos = [1, 3]
      else if L1_x < p2_x < L2_x
        approach = DIRECT_TOP
        #console.log "b"
        pos = [1, 3]
      else if L2_x < p2_x
        #console.log "c"
        approach = RIGHT
        pos = [1, 4]
        alt_pos = [2, 3]
        if very_tall
          approach = LEFT
          pos = [1, 3]
    else if L1_y < p2_y < L2_y
      if p2_x < L1_x
        #console.log "d"
        approach = DIRECT_RIGHT
        pos = [4, 2]
      else if L1_x < p2_x < L2_x
        ##console.log "e"
        # impossible.
      else if L2_x < p2_x
        #console.log "f"
        approach = DIRECT_RIGHT
        pos = [2, 4]
    else if L2_y < p2_y
      if p2_x < L1_x
        #console.log "g"
        approach = LEFT
        pos = [4, 1]
        alt_pos = [3, 2]
        if very_tall
          approach = RIGHT
          pos = [3, 1]

      else if L1_x < p2_x < L2_x
        #console.log "h"
        approach = DIRECT_BOTTOM
        pos = [3, 1]
      else if L2_x < p2_x
        #console.log "i"
        approach = LEFT
        pos = [2, 1]
        alt_pos = [3, 4]
        if very_tall
          pos = [3, 1]
    [pos1, pos2] = pos

    [sx, sy] = compound1._get_base_coords(pos1, 0)
    [x1, y1] = compound1._get_base_coords(pos1, 3)
    [x8, y8] = compound2._get_base_coords(pos2, 3)
    [ex, ey] = compound2._get_base_coords(pos2, 0)

    if alt_pos
      [alt_pos1, alt_pos2] = alt_pos
      if (map[x1]? and map[x1][y1]?) # if initial position from node A is busy, set alternative.
        [alt_x1, alt_y1] = compound1._get_base_coords(alt_pos1, 3)
        if not (map[alt_x1]? and map[alt_x1][alt_y1]?)
          [sx, sy] = compound1._get_base_coords(alt_pos1, 0)
          [x1, y1] = [alt_x1, alt_y1]

      else if approach == RIGHT and (map[x1]? and map[x1][y8]?) # if corner intersection is busy, set alternative.
        #console.log "ALTERNATIVE CORNER! A"
        [alt_x1, alt_y1] = compound1._get_base_coords(alt_pos1, 3)
        if not (map[alt_x1]? and map[alt_x1][alt_y1]?)
          [sx, sy] = compound1._get_base_coords(alt_pos1, 0)
          [x1, y1] = [alt_x1, alt_y1]

      if (map[x8]? and map[x8][y8]?) # if initial position from node B is busy, set alternative.
        [alt_x8, alt_y8] = compound2._get_base_coords(alt_pos2, 3)
        if not (map[alt_x8]? and map[alt_x8][alt_y8]?)
          [ex, ey] = compound2._get_base_coords(alt_pos2, 0)
          [x8, y8] = [alt_x8, alt_y8]

      else if (map[x8]? and map[x8][y1]?) # if corner intersection is busy, set alternative.
        #console.log "ALTERNATIVE CORNER! B"
        [alt_x8, alt_y8] = compound2._get_base_coords(alt_pos2, 3)
        if not (map[alt_x8]? and map[alt_x8][alt_y8]?)
          [ex, ey] = compound2._get_base_coords(alt_pos2, 0)
          [x8, y8] = [alt_x8, alt_y8]

    if approach == RIGHT
      #console.log " right..."
      #console.log "sx sy", [sx, sy]
      #console.log "x1 y1", [x1, y1]
      #console.log "x1 y8", [x1, y8]
      #console.log "x8 y8", [x8, y8]
      #console.log "ex ey", [ex, ey]
      r = [[sx, sy], [x1, y1], [x1, y8], [x8, y8], [ex, ey]]
      if x8 < ex
        [x8, y8] = [ex, ey]
      r = [[sx, sy], [x1, y1], [x1, y8], [x8, y8], [ex, ey]]

    else if approach == LEFT
      #console.log " left..."
      if x8 < ex
        [x8, y8] = [ex, ey]
      r = [[sx, sy], [x1, y1], [x8, y1], [x8, y8], [ex, ey]]

    else if approach == DIRECT_RIGHT
      #console.log "Direct right..."
      r = [[sx, y8], [x1, y8], [x8, y8], [ex, y8]]
    else if approach == DIRECT_LEFT
      #console.log "Direct left..."
      r = [[sx, y1], [x1, y1], [x8, y1], [ex, y1]]
    else if approach == DIRECT_BOTTOM
      #console.log "Direct bottom..."
      r = [[x8, sy], [x8, y1], [x8, y8], [x8, ey]]
    else if approach == DIRECT_TOP
      #console.log "Direct top..."
      r = [[x8, sy], [x8, y1], [x8, y8], [x8, ey]]
    return r
