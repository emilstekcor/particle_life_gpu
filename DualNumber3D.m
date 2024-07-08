classdef DualNumber3D
    properties
        x
        y
        z
        dx
        dy
        dz
    end

    methods
        function obj = DualNumber3D(x, y, z, dx, dy, dz)
            if nargin == 0
                obj.x = 0;
                obj.y = 0;
                obj.z = 0;
                obj.dx = 0;
                obj.dy = 0;
                obj.dz = 0;
            else
                obj.x = x;
                obj.y = y;
                obj.z = z;
                obj.dx = dx;
                obj.dy = dy;
                obj.dz = dz;
            end
        end

        function result = plus(a, b)
            result = DualNumber3D(a.x + b.x, a.y + b.y, a.z + b.z, a.dx + b.dx, a.dy + b.dy, a.dz + b.dz);
        end

        function result = minus(a, b)
            result = DualNumber3D(a.x - b.x, a.y - b.y, a.z - b.z, a.dx - b.dx, a.dy - b.dy, a.dz - b.dz);
        end

        function result = mtimes(a, b)
            result = DualNumber3D(a.x * b.x, a.y * b.y, a.z * b.z, ...
                                  a.dx * b.x + a.x * b.dx, ...
                                  a.dy * b.y + a.y * b.dy, ...
                                  a.dz * b.z + a.z * b.dz);
        end

        function result = mrdivide(a, b)
            result = DualNumber3D(a.x / b.x, a.y / b.y, a.z / b.z, ...
                                  (a.dx * b.x - a.x * b.dx) / (b.x ^ 2), ...
                                  (a.dy * b.y - a.y * b.dy) / (b.y ^ 2), ...
                                  (a.dz * b.z - a.z * b.dz) / (b.z ^ 2));
        end

        function result = power(a, b)
            result = DualNumber3D(a.x ^ b.x, a.y ^ b.y, a.z ^ b.z, ...
                                  b.x * (a.x ^ (b.x - 1)) * a.dx, ...
                                  b.y * (a.y ^ (b.y - 1)) * a.dy, ...
                                  b.z * (a.z ^ (b.z - 1)) * a.dz);
        end
    end
end
