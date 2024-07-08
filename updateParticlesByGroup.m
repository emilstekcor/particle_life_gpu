function [pos, vel] = updateParticlesByGroup(pos, vel, ids, forceMatrices, dt, forceLevel)
    % This function is intended for GPU execution
    coder.gpu.kernelfun;

    N = size(pos, 1);
    forces = DualNumber3D(zeros(N, 1), zeros(N, 1), zeros(N, 1), zeros(N, 1), zeros(N, 1), zeros(N, 1));

    % Update each particle based on its group's force matrix
    for i = 1:N
        id = ids(i);
        forceMatrix = forceMatrices{id};

        % Check if forceMatrix is zero, skip calculation if true
        if forceMatrix == 0
            continue;
        end

        % Extract position and velocity components
        pos_vec = [pos(i).x; pos(i).y; pos(i).z];
        vel_vec = [vel(i).x; vel(i).y; vel(i).z];

        % Compute force using the force matrix and apply scaling
        force = forceLevel * (forceMatrix * [pos_vec; vel_vec]);

        % Store the computed forces
        forces(i).x = force(1);
        forces(i).y = force(2);
        forces(i).z = force(3);
    end

    % Update velocities and positions using the computed forces
    for i = 1:N
        vel(i).x = vel(i).x + forces(i).x * dt.x;
        vel(i).y = vel(i).y + forces(i).y * dt.y;
        vel(i).z = vel(i).z + forces(i).z * dt.z;

        pos(i).x = pos(i).x + vel(i).x * dt.x;
        pos(i).y = pos(i).y + vel(i).y * dt.y;
        pos(i).z = pos(i).z + vel(i).z * dt.z;
    end
end
