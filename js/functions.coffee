window.GRID_SIZE = 4
window.get_c2m_point= (p) ->
# canvas to map point
  Math.ceil(p/GRID_SIZE)

window.get_m2c_point= (p) ->
# map to canvas point
  p * GRID_SIZE

window.get_m2m_point= (p) ->
# map to map point
  Math.ceil(p/GRID_SIZE) * GRID_SIZE


