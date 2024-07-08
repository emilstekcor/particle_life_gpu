global stepSpeedTextbox forceLevelTextbox numParticlesTextbox frictionTextbox interactionRangeTextbox minRadiusTextbox;
global pos vel ids forceMatrices interactionMatrix N dt forceLevel friction interactionRange minRadius hm;
global clickTimer clickPoint clickIncrement isPaused pauseButton cellSize overlap;

% Initialize Parameters
N = 1000; % Initial number of particles
dt = 0.01; % Initial time step
forceLevel = 10.0; % Initial force level (scaled up for better clarity)
friction = 0.5; % Friction coefficient (time to halve speed)
interactionRange = 0.5; % Interaction range for particles
minRadius = 0.1; % Minimum radius to prevent clustering
clickIncrement = 0.1; % Increment value for holding click
isPaused = false; % Simulation pause state
cellSize = 0.2; % Size of each grid cell
overlap = 0.1; % Overlap between adjacent grid cells

% Initialize Figure for Visualization
fig = figure('Position', [100, 100, 1800, 600]);

% Subplot for Particle Visualization
subplot(1, 2, 1);
h = scatter3(rand(N,1), rand(N,1), rand(N,1), 36, int32(randi([1, 5], N, 1)), 'filled');
title('Particle Life Simulation');
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;
axis([0 1 0 1 0 1]);
view(3); % Start with 3D view
is3D = true;
drawnow;


% Subplot for Interaction Matrix Visualization
subplot(1, 2, 2);
hm = imagesc(interactionMatrix); % Initialize with interactionMatrix values
colorbar;
title('Interaction Matrix');
xlabel('Group');
ylabel('Group');
axis square;

% Set the colormap (choose a suitable one)
colormap('jet'); % Example: using the 'jet' colormap

% Adjusted UI Controls Position
ui_x_position = 1600; % Adjusted x-position to move controls to the right

% Add UI Controls for Step Speed, Force Level, Number of Particles, Friction, Interaction Range, and Minimum Radius
uicontrol('Style', 'text', 'Position', [ui_x_position, 580, 100, 20], 'String', 'Step Speed');
stepSpeedTextbox = uicontrol('Style', 'edit', 'Position', [ui_x_position, 550, 120, 20], 'String', num2str(dt), 'Callback', @updateParameters);
uicontrol('Style', 'text', 'Position', [ui_x_position, 520, 100, 20], 'String', 'Force Level');
forceLevelTextbox = uicontrol('Style', 'edit', 'Position', [ui_x_position, 490, 120, 20], 'String', num2str(forceLevel), 'Callback', @updateParameters);
uicontrol('Style', 'text', 'Position', [ui_x_position, 460, 100, 20], 'String', 'Num Particles');
numParticlesTextbox = uicontrol('Style', 'edit', 'Position', [ui_x_position, 430, 120, 20], 'String', num2str(N), 'Callback', @updateParameters);
uicontrol('Style', 'text', 'Position', [ui_x_position, 400, 100, 20], 'String', 'Friction');
frictionTextbox = uicontrol('Style', 'edit', 'Position', [ui_x_position, 370, 120, 20], 'String', num2str(friction), 'Callback', @updateParameters);
uicontrol('Style', 'text', 'Position', [ui_x_position, 340, 100, 20], 'String', 'Interaction Range');
interactionRangeTextbox = uicontrol('Style', 'edit', 'Position', [ui_x_position, 310, 120, 20], 'String', num2str(interactionRange), 'Callback', @updateParameters);
uicontrol('Style', 'text', 'Position', [ui_x_position, 280, 100, 20], 'String', 'Min Radius');
minRadiusTextbox = uicontrol('Style', 'edit', 'Position', [ui_x_position, 250, 120, 20], 'String', num2str(minRadius), 'Callback', @updateParameters);
uicontrol('Style', 'pushbutton', 'Position', [ui_x_position, 220, 100, 30], 'String', 'Clear Matrix', 'Callback', @clearMatrix);
pauseButton = uicontrol('Style', 'pushbutton', 'Position', [ui_x_position, 190, 100, 30], 'String', 'Pause', 'Callback', @togglePause);

% Initialize Simulation
initializeSimulation();

% Run the Simulation
while ishandle(fig)
    if ~isPaused
        % Get current values from textboxes, with error handling
        if ishandle(stepSpeedTextbox)
            dt = str2double(get(stepSpeedTextbox, 'String'));
        end
        if ishandle(forceLevelTextbox)
            forceLevel = str2double(get(forceLevelTextbox, 'String'));
        end
        if ishandle(frictionTextbox)
            friction = str2double(get(frictionTextbox, 'String'));
        end
        if ishandle(interactionRangeTextbox)
            interactionRange = str2double(get(interactionRangeTextbox, 'String'));
        end
        if ishandle(minRadiusTextbox)
            minRadius = str2double(get(minRadiusTextbox, 'String'));
        end
        if ishandle(numParticlesTextbox)
            newN = round(str2double(get(numParticlesTextbox, 'String')));
        else
            newN = N; % Use current N if UI is not available
        end
        
        % Update number of particles if changed
        if newN ~= N
            N = newN;
            initializeSimulation();
            set(h, 'XData', pos(:,1), 'YData', pos(:,2), 'ZData', pos(:,3), 'CData', ids);
        end
        
        % Update particles using spatial partitioning or group-based update
        %[pos, vel] = updateParticlesWithGrid(pos, vel, ids, forceMatrices, dt, forceLevel, interactionMatrix, friction, interactionRange, minRadius, cellSize, overlap);
        [pos, vel] = updateParticlesByGroup(pos, vel, ids, forceMatrices, dt, forceLevel);

        % Enforce Periodic Boundary Conditions
        pos = mod(pos, 1); % Wrap positions within [0, 1]
        
        % Update Visualization
        if is3D
            set(h, 'XData', pos(:,1), 'YData', pos(:,2), 'ZData', pos(:,3), 'CData', ids);
        else
            set(h, 'XData', pos(:,1), 'YData', pos(:,2), 'CData', ids);
        end
        
        % Update Interaction Matrix Visualization
        set(hm, 'CData', interactionMatrix);
        drawnow;
    else
        pause(0.01); % Prevent busy-waiting
    end
end

disp('Simulation completed.');


function [pos, vel] = updateParticlesWithGrid(pos, vel, ids, forceMatrices, dt, forceLevel, interactionMatrix, friction, interactionRange, minRadius, cellSize, overlap)
    % Initialize forces array
    forces = zeros(size(pos));

    % Loop over each particle to calculate forces
    N = size(pos, 1);
    for i = 1:N
        for j = i+1:N
            % Compute distance and force vector
            r_ij = pos(i, :) - pos(j, :);
            dist = norm(r_ij);

            % Get interaction strength from matrix
            id_i = ids(i); % Particle i's group ID
            id_j = ids(j); % Particle j's group ID
            interactionStrength = interactionMatrix(id_i, id_j);

            % Calculate force using modified calculateForce function
            if interactionStrength ~= 0 && dist < interactionRange && dist > minRadius
                force = calculateForce(forceLevel, r_ij, minRadius, interactionMatrix, ids([i, j]));
                forces(i, :) = forces(i, :) + force;
                forces(j, :) = forces(j, :) - force; % Opposite force on the other particle
            end
        end
        
        % Apply friction
        vel(i, :) = applyFriction(vel(i, :), friction, dt);
        
        % Update position based on velocity
        pos(i, :) = pos(i, :) + vel(i, :) * dt;
        
        % Enforce periodic boundary conditions (if needed)
        % Example: pos(i, :) = mod(pos(i, :), 1);
    end
end




function vel = applyFriction(vel, friction, dt)
    % Apply friction to velocity
    vel = vel * exp(-friction * dt);
end


function forces = calculateForces(particles, pos, vel, ids, forceMatrices, dt, forceLevel, interactionMatrix, friction, interactionRange, minRadius, forces, adjParticles)
    if nargin < 14
        adjParticles = particles; % Default to self if no adjacent particles specified
    end

    % Calculate forces between particles
    for i = 1:length(particles)
        id_i = ids(particles(i));
        for j = 1:length(adjParticles)
            if particles(i) ~= adjParticles(j)
                id_j = ids(adjParticles(j));
                interactionStrength = interactionMatrix(id_i, id_j);

                % Compute distance and force vector
                r_ij = pos(particles(i), :) - pos(adjParticles(j), :);
                dist = norm(r_ij);

                if dist < interactionRange && dist > minRadius
                    % Calculate force
                    force = interactionStrength * (1 - abs(1 + minRadius - 2 * dist) / (1 - minRadius));
                    forces(particles(i), :) = forces(particles(i), :) + forceLevel * force * (r_ij / dist);
                end
            end
        end
    end
end

function adjacentCells = getAdjacentCells(cellX, cellY, cellZ, numCells, overlap)
    % Get a list of adjacent cells considering overlap
    adjacentCells = [];
    for x = max(1, cellX-1):min(numCells, cellX+1)
        for y = max(1, cellY-1):min(numCells, cellY+1)
            for z = max(1, cellZ-1):min(numCells, cellZ+1)
                if ~(x == cellX && y == cellY && z == cellZ)
                    adjacentCells = [adjacentCells; x, y, z];
                end
            end
        end
    end
end

function keyPressCallback(~, event)
    % Handle key press events
    if strcmp(event.Key, 'space')
        togglePause();
    elseif strcmp(event.Key, 'v')
        switchView();
    end
end

function switchView()
    % Toggle between 2D and 3D view
    persistent is3D;
    if isempty(is3D)
        is3D = true;
    end
    if is3D
        view(2);
        zlabel('');
    else
        view(3);
        zlabel('Z');
    end
    is3D = ~is3D;
end

function initializeSimulation()
    % Initialize or reinitialize simulation variables
    global pos vel ids forceMatrices interactionMatrix N dt forceLevel;

    pos = rand(N, 3); % Random positions within [0, 1]
    vel = rand(N, 3) * 2 - 1; % Random velocities within [-1, 1]
    ids = int32(randi([1, 5], N, 1)); % Assign each particle to one of 5 groups (as int32)

    % Define force matrices for each group
    forceMatrices = cell(1, 5); % Define as a row vector
    for i = 1:5
        forceMatrices{i} = rand(6, 6); % Replace with your force matrix logic
    end

    % Initialize Interaction Matrix
    if isempty(interactionMatrix) || size(interactionMatrix, 1) ~= 5 || size(interactionMatrix, 2) ~= 5
        interactionMatrix = rand(5, 5) * 2 - 1; % Initialize interaction strengths between groups with values between -1 and 1
    end
end

function updateParameters(~, ~)
    global stepSpeedTextbox forceLevelTextbox numParticlesTextbox frictionTextbox interactionRangeTextbox minRadiusTextbox;
    global dt forceLevel N friction interactionRange minRadius;
    
    if ishandle(stepSpeedTextbox)
        dt = str2double(get(stepSpeedTextbox, 'String'));
    end
    if ishandle(forceLevelTextbox)
        forceLevel = str2double(get(forceLevelTextbox, 'String'));
    end
    if ishandle(frictionTextbox)
        friction = str2double(get(frictionTextbox, 'String'));
    end
    if ishandle(interactionRangeTextbox)
        interactionRange = str2double(get(interactionRangeTextbox, 'String'));
    end
    if ishandle(minRadiusTextbox)
        minRadius = str2double(get(minRadiusTextbox, 'String'));
    end
    if ishandle(numParticlesTextbox)
        newN = round(str2double(get(numParticlesTextbox, 'String')));
    end

    % Check if the number of particles has changed
    if newN ~= N
        N = newN;
        initializeSimulation();
    end
end


function matrixClickCallback(~, ~)
    % Handle clicks on the interaction matrix to change values
    global interactionMatrix hm clickTimer clickPoint clickIncrement;

    % Get the click position
    point = get(gca, 'CurrentPoint');
    x = round(point(1, 1));
    y = round(point(1, 2));
    
    % Ensure the click is within the matrix bounds
    if x >= 1 && x <= size(interactionMatrix, 2) && y >= 1 && y <= size(interactionMatrix, 1)
        clickPoint = [x, y];
        
        % Determine the type of click (left, middle, or right)
        clickType = get(gcf, 'SelectionType');
        switch clickType
            case 'normal' % Left click
                interactionMatrix(y, x) = min(1, interactionMatrix(y, x) + clickIncrement); % Increase by increment, max value 1
                startClickTimer(); % Start the timer for continuous increment
            case 'alt' % Right click
                interactionMatrix(y, x) = max(-1, interactionMatrix(y, x) - clickIncrement); % Decrease by increment, min value -1
            case 'extend' % Middle click
                interactionMatrix(y, x) = 0; % Clear the value
        end
        
        % Update the visualization
        updateInteractionMatrixVisualization();
    end
end

function stopMatrixClickCallback(~, ~)
    % Stop the timer when mouse button is released
    global clickTimer;

    if ~isempty(clickTimer) && isvalid(clickTimer)
        stop(clickTimer);
        delete(clickTimer);
        clickTimer = [];
    end
end

function startClickTimer()
    % Start the timer for continuous increment on hold
    global clickTimer clickPoint interactionMatrix clickIncrement;

    if isempty(clickTimer) || ~isvalid(clickTimer) || ~strcmp(clickTimer.Running, 'on')
        clickTimer = timer('ExecutionMode', 'fixedSpacing', 'Period', 0.2, 'TimerFcn', @incrementMatrixValue);
        start(clickTimer);
    end
    
    function incrementMatrixValue(~, ~)
        % Increment the matrix value at the clicked position
        x = clickPoint(1);
        y = clickPoint(2);
        interactionMatrix(y, x) = min(1, interactionMatrix(y, x) + clickIncrement); % Increase by increment, max value 1
        
        % Update the visualization
        updateInteractionMatrixVisualization();
    end
end


function clearMatrix(~, ~)
    % Clear the entire interaction matrix
    global interactionMatrix;

    interactionMatrix = zeros(size(interactionMatrix)); % Set all values to 0
    updateInteractionMatrixVisualization();
end

function togglePause(~, ~)
    % Toggle the simulation pause state
    global isPaused pauseButton;
    isPaused = ~isPaused;
    if isPaused
        set(pauseButton, 'String', 'Resume');
    else
        set(pauseButton, 'String', 'Pause');
    end
end

function updateInteractionMatrixVisualization()
    % Update the interaction matrix visualization
    global interactionMatrix hm;

    set(hm, 'CData', interactionMatrix);
    minVal = -1; % Set minimum value to -1
    maxVal = 1;  % Set maximum value to 1
    caxis([minVal, maxVal]); % Adjust color scaling
    drawnow;
end

function force = calculateForce(a, pos, rmin, interactionMatrix, ids)
    % Calculate force based on distance and radius, using interactionMatrix
    dist = norm(pos); % Calculate Euclidean distance
    id_i = ids(1); % Assuming ids is a vector where ids(1) is the particle's group ID
    interactionStrength = interactionMatrix(id_i, id_i); % Interaction strength for the particle's group

    if interactionStrength ~= 0 % Only calculate force if interaction strength is non-zero
        if dist < rmin
            force = pos * (dist / rmin - 1);
        else
            force = a * interactionStrength * (1 - abs(1 + rmin - 2 * dist) / (1 - rmin));
            force = force * (pos / dist); % Normalize pos vector
        end
    else
        force = [0, 0, 0]; % No force if interaction strength is 0
    end
end


function [pos, vel] = updateParticlesByGroup(pos, vel, ids, forceMatrices, dt, forceLevel)
    % This function updates particles based on group-specific forces
    N = size(pos, 1);
    forces = zeros(N, 3); % Initialize forces array

    % Update each particle based on its group's force matrix
    for i = 1:N
        id = ids(i);
        forceMatrix = forceMatrices{id};

        % Compute force using the force matrix
        force = forceLevel * (forceMatrix * [pos(i, :), vel(i, :)]');

        % Update velocity and position
        vel(i, :) = vel(i, :) + force(1:3)' * dt;
        pos(i, :) = pos(i, :) + vel(i, :) * dt;
    end
end
