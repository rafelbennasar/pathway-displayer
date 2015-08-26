'use strict'



class Pathway

  constructor: (@id, @title, @description, @width, @height) ->
    console.log "[INFO] Initialised pathway #{@id}"

    @compounds = {}
    @reactions = {}
    @compound_groups = {}

    @map = {}
    @virtual_compounds = {}
    @map_compounds = {}
    @virtual_compound_id = -1

    @virtual_reactions = {}
    @layer = new paper.Layer()



  ###
  # get_compound_instance: (compound_id) returns compound_id
  #
  # Given a compound_id, we get another compound id. If it is a positive
  # integer is a 'normal compound'; if it is a negative integer is a
  # virtual compound that is created from two or more compounds.
  ###
  get_compound_instance: (compound_id) ->
    if @map_compounds[compound_id]?
      return @map_compounds[compound_id]
    return compound_id


  set_map: (compound_id) ->
    compound = @compounds[compound_id]
    position = compound["position"]
    [w, h] = [compound["size"][0], compound["size"][1]]
    [x1, y1, x2, y2] = [parseInt(position[0] - (w/2)), parseInt(position[1] - (h/2)), parseInt(position[0] + (w/2)), parseInt(position[1] + (h/2))]
    for x in [x1..x2-1]
      @map[x] ?= {}
      for y in [y1..y2-1]
        @map[x][y] = compound_id

  ###
  # get_4_neighbors_compound
  # This function returns the neighbour points for the compound group
  # generation. So, given a compound_id it returns the N, W, E, S from
  # that compound (or virtual compound).
  #
  #       N
  #   ---------
  # W |  cpd  | E
  #   ---------
  #       S
  ###
  get_compound_neighbors: (compound_id) ->
    c_id = @.get_compound_instance(compound_id)
    c = @compounds[c_id]
    [wd, hd] = [parseInt(c.size[0]/2), parseInt(c.size[1]/2)]
    [x, y] = [parseInt(c.position[0]), parseInt(c.position[1])]

    compound_list = []
    coords = [
      [x-wd-1, y],
      [x+wd, y],
      [x, y-hd-1],
      [x, y-hd-2],
      [x, y+hd],
      [x-wd-1, y-hd-1],
      [x+wd+1, y-hd-1],
    ]

    for [sx, sy] in coords
      if @.is_busy_coords(sx, sy)
        compound_list.push(@.get_compound_coords(sx, sy))
    return compound_list

  is_busy: (point) ->
    [x, y] = [point[0], point[1]]
    return (@map[x]? and @map[x][y]?)

  is_busy_coords: (x, y) ->
    return (@map[x]? and @map[x][y]?)

  get_compound: (point) ->
    [x, y] = [point[0], point[1]]
    if (@map[x]? and @map[x][y]?)
      return @map[x][y]

  get_compound_coords: (x, y) ->
    if (@map[x]? and @map[x][y]?)
      return @map[x][y]


  build_virtual_compounds: () ->
    """ In order to build the virtual compounds in two steps:
      1. build the virtual compounds groups. Which groups we have.
      2. Later, we

    """
    pending = Object.keys(@compounds)

    c_group = {}
    visited = []
    while pending.length > 0
      compound_id = pending.pop()
      opened = [compound_id, ]
      visited.push(compound_id)
      c_group[compound_id] = [compound_id, ]
      while opened.length > 0
        c_id = opened.pop()
        for new_compound in @.get_compound_neighbors(c_id)
          if new_compound not in visited
            visited.push(new_compound)
            opened.push(new_compound)
            c_group[compound_id].push(new_compound)
      pending = (x for x in pending when visited.indexOf(x) == -1 )

    [min, max, inf] = [Math.min, Math.max, 32768]
    for compound_id of c_group
      if c_group[compound_id].length > 1
        @virtual_compound_id -= 1
        @virtual_compounds[@virtual_compound_id] = c_group[compound_id]

        [min_x, min_y, max_x, max_y] = [inf, inf, -inf, -inf]
        for cmp_id in c_group[compound_id]
          cmp = @compounds[cmp_id]
          @compounds[cmp_id].virtual_compound_id = @virtual_compound_id
          [p, s] = [cmp.position, cmp.size]
          [min_x, min_y] = [parseInt(min(min_x, p[0] - s[0]/2)), parseInt(min(min_y, p[1] - s[1]/2))]
          [max_x, max_y] = [parseInt(max(max_x, p[0] + s[0]/2)), parseInt(max(max_y, p[1] + s[1]/2))]

        size = [get_m2c_point(max_x - min_x), get_m2c_point(max_y - min_y)]
        position = [get_m2c_point(max_x) - size[0]/2, get_m2c_point(max_y) - size[1]/2]
        @._add_compound(compound_id=@virtual_compound_id,
                        "Virtual cmp " + @virtual_compound_id,
                        "Virtual cmp",
                        position,
                        size,
                        "square",
                        ["red", "blue"])


  _add_compound: (compound_id, label, description, position, size, shape, color, virtual=false) ->
    try
      @compounds[compound_id] = new Compound(id=compound_id, label=label, description=description, position=[get_c2m_point(position[0]), get_c2m_point(position[1]) ], size=[get_c2m_point(size[0]), get_c2m_point(size[1])], shape=shape, color=color, path=@path, virtual=virtual)
      # We use this max size to determine the best initial zoom.
      m_size_x = get_m2c_point(position[0] + size[0])
      if not @max_size_x? or m_size_x > @max_size_x
        @max_size_x = m_size_x
      m_size_y = get_m2c_point(position[1] + size[1])
      if not @max_size_y? or m_size_y > @max_size_y
        @max_size_y = m_size_y

    catch error
      console.log "[ERROR] Trying to add compoound id:", compound_id
      console.log error

  add_compound_list: (compound_list) ->
    for c in compound_list
      @._add_compound(c.id, c.label, c.description, c.position, c.size, c.shape, c.color)
      @.set_map(c.id)
    @.build_virtual_compounds()
    console.log "all compounds added... max size was", @max_size_x, @max_size_y

  set_pathway_offsets: (x, y) ->
    @layer.translate(x, y)
    @layer.activate()

  _add_reaction: (id, label, compound1_id, compound2_id, type) ->
    compound1 = @compounds[compound1_id]
    compound2 = @compounds[compound2_id]
    if @reactions[id]?
      @reactions[id].push(new Reaction(id, label, compound1, compound2, type))
    else
      @reactions[id] = [new Reaction(id, label, compound1, compound2, type), ]

    if compound1.virtual_compound_id?
      cpd1_v = compound1.virtual_compound_id
    else
      cpd1_v = compound1.id

    if compound2.virtual_compound_id?
      cpd2_v = compound2.virtual_compound_id
    else
      cpd2_v = compound2.id

    if cpd1_v > cpd2_v
      [cpd1_v, cpd2_v] = [cpd2_v, cpd1_v]

    if @virtual_reactions[[cpd1_v, cpd2_v]]?
      if type not in @virtual_reactions[[cpd1_v, cpd2_v]]['type']
        @virtual_reactions[[cpd1_v, cpd2_v]]['type'].push type
        @virtual_reactions[[cpd1_v, cpd2_v]]['reaction'].push id
    else
      @virtual_reactions[[cpd1_v, cpd2_v]] = {'type': [type], 'reaction': [id]}

    # For each reaction of our pathways, we have to know in which
    # virtual reaction is included. In this way, it's much easier to print
    # it later.
    for r in @reactions[id]
      r.append_virtual_reaction([cpd1_v, cpd2_v])

      
  add_reaction_list: (reaction_list) ->
    for r in reaction_list
      @._add_reaction(r.id, r.label, r.compound1_id, r.compound2_id, r.type)
    paper.view.draw();
    @.draw_reactions()

  draw_reactions: () ->
    for r of @virtual_reactions
      [cpd1, cpd2] = [r.split(",")[0], r.split(",")[1]]
      try
        [p1, p2] = [@compounds[cpd1].position, @compounds[cpd2].position]
        reaction_path = Reaction.get_coords(@compounds[cpd1], @compounds[cpd2], @map)
        paper_path = new paper.Path();
        paper_path.strokeColor = 'black';

        for r_id in @virtual_reactions[r]["reaction"]
          for s in @reactions[r_id]
            s.append_path(paper_path)

        for p in reaction_path
          paper_path.add(new paper.Point(p[0]*4, p[1]*4));
      catch error
        console.log "--- oops", error
        console.log "cpd1", cpd1, "cpd2", cpd2, "::"
        console.log "r", r
    paper.view.draw();

SELECTED_GROUP = null

class AlignResult
  constructor: (@id, r_align, reaction1, reaction2) ->
    color1 = r_align["color1"]
    color2 = r_align["color2"]

    @g1 = new paper.Group()
    @g2 = new paper.Group()

    try
      for r3 in reaction1
        for r4 in r3["paths"]
          @g1.addChild(r4)
      for r3 in reaction2
        for r4 in r3["paths"]
          @g2.addChild(r4)
    catch e
      console.log "error adding groups"
      console.log e

    style_aligned = {
      opacity: 1
      strokeColor: color1
      strokeWidth: 3
      closed: false }
    style_highlighted = {
      opacity: 1
      strokeColor: color2
      strokeWidth: 3
      closed: false }
    @g1.style = style_aligned
    @g2.style = style_aligned

    @g1.onMouseEnter = (event) =>
      if SELECTED_GROUP?
        SELECTED_GROUP[0].style = style_aligned
        SELECTED_GROUP[1].style = style_aligned
      SELECTED_GROUP = [@g1, @g2]
      @g1.bringToFront()
      @g2.bringToFront()
      @g1.style = style_highlighted
      @g2.style = style_highlighted

    @g2.onMouseEnter = (event) =>
      if SELECTED_GROUP?
        SELECTED_GROUP[0].style = style_aligned
        SELECTED_GROUP[1].style = style_aligned
      SELECTED_GROUP = [@g1, @g2]
      @g1.bringToFront()
      @g2.bringToFront()
      @g1.style = style_highlighted
      @g2.style = style_highlighted


class iEnhancedCanvas
  constructor: (@canvas_id) ->
    @compounds = {}
    @pathway_list = []

    @canvas = document.getElementById(@canvas_id);
    paper.setup(@canvas);
    @paper_view = paper.view


  setup: ->

    width = paper.view.size.width/ @pathway_list.length
    [w, h] = [$(document).width(), $(document).height()]
    console.log paper.view.size.width
    [total_size_x, total_size_y] = [0, 0]
    @pathway_list.forEach (pathway, e) ->
      total_size_x += pathway.max_size_x
      total_size_y = Math.max(total_size_y, pathway.max_size_y)
    z1 = ($(document).width()/total_size_x)
    z2 = ($(document).height()/total_size_y)
    z = Math.min(z1, z2)
    console.log "Size", w, h
    console.log "Z", z, z1, z2
    console.log total_size_x, $(document).width()
    console.log total_size_y, $(document).height()
    if z < 1
      paper.view.zoom = z
      paper.view.center = [total_size_x/2, total_size_y/2] #(h + h*z)/4] #[w/0.9, h/0.9]

    width = paper.view.size.width/ @pathway_list.length
    @pathway_list.forEach (pathway, e) ->
      pathway.set_pathway_offsets(e*width, 0)
      paper.view.draw()

  list_pathways: ->
    console.log 'Pathways' + pathway_list

  new_pathway: (id, title, description, width, height, canvas_id) ->

    console.log "[INFO] Adding pathway #{id} (#{width}, #{height})"
    console.log "       Title: #{title}"
    console.log "       Description: #{description}"
    pathway = new Pathway(id, canvas_id, title, description, width, height)
    @pathway_list.push(pathway)
    return pathway

  add_result: (result_list) ->
    result_group = {}

    for r_align in result_list
      align_id = r_align["id"]
      reaction1 = @pathway_list[r_align['pathway1_id']]["reactions"][r_align["reaction1_id"]]
      reaction2 = @pathway_list[r_align['pathway2_id']]["reactions"][r_align["reaction2_id"]]
      result_group[align_id] = new AlignResult(align_id, r_align, reaction1, reaction2)
    paper.view.draw()

root = exports ? this
unless root.iEnhancedCanvas
  root.iEnhancedCanvas = iEnhancedCanvas
