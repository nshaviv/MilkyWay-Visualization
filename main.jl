 
# read in all the functions
begin
    include("src/parameters.jl")
    include("src/physics.jl")
    include("src/graphics.jl")
end

# Run the simulation 
begin
    # Open the graphics window and initialize the physics 
    fig, ax = init_graphics()
    init_physics()

    # Setupp the simulation time and the animation function
    t0 = time()
    t = Observable(0.0)
    @lift(draw_scene!(ax, $t))

    display(fig)

    # Start the animation loop. 
    fps = 30.0
    @async begin
    while isopen(fig.scene)
        t[] = (time() - t0)*20
        sleep(1/fps)
    end
    end
end
