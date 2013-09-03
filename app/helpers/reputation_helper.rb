module ReputationHelper

  # Sumo o resto una determinada cantidad de puntos al usuario
  # Si no está cancelando una operación anterior sumo en la reputación
  # real y en la reputación normal.
  # Si está cancelando una operación anterior sólo sumo en la normal 
  # si la real es igual.
  def new_reputation(user, points, cancelling = false)
    if cancelling
      points = points * -1
      user.reputation += points unless user.real_reputation != user.reputation
    else
     user.reputation += points 
    end
    user.real_reputation += points
    (user.reputation = 1) if user.reputation < 1
    logger.debug user.inspect
    user.save
    return true
  end

end