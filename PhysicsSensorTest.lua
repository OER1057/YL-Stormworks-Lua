sin = math.sin
cos = math.cos

function turnAboutX(vector, X)
    return {
        x = vector.x,
        y = vector.y * cos(X) + vector.z * sin(X),
        z = -vector.y * sin(X) + vector.z * cos(X)
    }
end

function turnAboutY(vector, Y)
    return {
        x = vector.x * cos(Y) + vector.z * sin(Y),
        y = vector.y,
        z = -vector.x * sin(Y) + vector.z * cos(Y)
    }
end

function turnAboutZ(vector, Z)
    return {
        x = vector.x,
        y = vector.y * cos(Z) + vector.z * sin(Z),
        z = -vector.y * sin(Z) + vector.z * cos(X)
    }
end

function onTick()
    X = input.getNumber(4)
    Y = input.getNumber(5)
    Z = input.getNumber(6)
    cx = input.getNumber(1)
    cy = input.getNumber(2)
    cz = input.getNumber(3)
    xx = input.getNumber(7)
    xy = input.getNumber(8)
    xz = input.getNumber(9)
    yx = input.getNumber(10)
    yy = input.getNumber(11)
    yz = input.getNumber(12)
    zx = input.getNumber(13)
    zy = input.getNumber(14)
    zz = input.getNumber(15)
    --[[
    output.setNumber(1, cos(Y) * cos(Z))
    output.setNumber(2, cos(Y) * sin(Z))
    output.setNumber(3, -sin(Y))
    output.setNumber(4, xx - cx)
    output.setNumber(5, xy - cy)
    output.setNumber(6, xz - cz)
    --]]
    --[[
    output.setNumber(1, sin(X) * sin(Y) * cos(Z) - cos(X) * sin(Z))
    output.setNumber(2, sin(X) * sin(Y) * sin(Z) + cos(X) * cos(Z))
    output.setNumber(3, sin(X) * cos(Y))
    output.setNumber(4, yx - cx)
    output.setNumber(5, yy - cy)
    output.setNumber(6, yz - cz)
    --]]
    ---[[
    output.setNumber(1, cos(X) * sin(Y) * cos(Z) + sin(X) * sin(Z))
    output.setNumber(2, cos(X) * sin(Y) * sin(Z) - sin(X) * cos(Z))
    output.setNumber(3, cos(X) * cos(Y))
    output.setNumber(4, zx - cx)
    output.setNumber(5, zy - cy)
    output.setNumber(6, zz - cz)
    --]]
end
