require("Constants.Units")

function coordinateToHeading(originNorth, originEast, targetNorth, targetEast) -- deg(北→東)
    return (math.atan(targetEast - originEast, targetNorth - originNorth) * _RAD_TO_DEG) % 360
end
