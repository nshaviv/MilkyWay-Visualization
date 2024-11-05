using GLMakie
using Images

# Initialize the graphics
function init_graphics()
    # Open a graphics window
    fig = Figure(size=(1200, 1200), backgroundcolor=:black)
    ax  = Axis3(fig[1, 1], aspect=(1, 1, 0.1))
    return fig, ax
end 

# This is the main function that draws the scene
function draw_scene!(ax, t)
    # Clear the previous scene
    empty!(ax)    
    # Set the axes limtis 
    limits!(ax, -30.0, 30.0, -30.0, 30.0, -3.0, 3.0)
    # Do we want to draw an axes box? (The default is a black box, but the background is black, so either we remove it or make it white)
    if frame_draw 
        color_box(ax,:white)
    else 
        remove_box(ax)
    end
    # Now loop over the populations
    for (i,pop) ∈ enumerate(pops)

        # Calculate the positions of the objects in each population.
        # Note that the birth time and phases can be updated by the function 
        x, y, z = pop_locations_at_time!(t, pop)

        # If it is the sun, we plot the orbit as well.
        if pop.label == "Sun"
            sun_array = [pop_locations_at_time!(tt, pop) for tt = t-64*num_z_orbits:1:t]
            lines!(ax, map(x->x[1][1], sun_array), map(x->x[2][1], sun_array), 
                       map(x->x[3][1], sun_array), color=:yellow, linewidth=3)
            scatter!(ax, [sun_array[end][1][1]], [sun_array[end][2][1]], 
                         [sun_array[end][3][1]], color=:yellow, markersize = pop.marker_size)
        else
            marker_sizes = pop.marker_sizes[1:end]
            colors = pop.colors[1:end]
            if pop.type == 2
                selection = [ t > pop.stars_start[i] * pop.lifes[pop.parent_cluster[i]] + pop.birth_times[pop.parent_cluster[i]] && 
                               t < pop.stars_end[i] * pop.lifes[pop.parent_cluster[i]] + pop.birth_times[pop.parent_cluster[i]] ? 
                               true : false  for i = 1:pop.num_kids]
                x = x[selection]
                y = y[selection]
                z = z[selection]
                marker_sizes = pop.marker_sizes[selection]
                colors = pop.colors[selection]
            end
            if length(x) == 0
                continue
            end
            if pop.mesh 
                meshscatter!(ax, x, y, z, markersize=0.05 .* marker_sizes, color=colors[i], 
                              transparency=true, alpha=pop.α, 
                              overdraw = true)
            else
                 scatter!(ax, x, y, z, markersize=marker_sizes, color = colors, 
                         transparency=true, alpha=pop.α, 
                         overdraw = true)
            end
        end 
    end
end


# Change the axes box. Is there no single command that can do this?
function remove_box(ax)
    ax.xspinesvisible = false
    ax.yspinesvisible = false
    ax.zspinesvisible = false
    ax.xticklabelsvisible = false
    ax.yticklabelsvisible = false
    ax.zticklabelsvisible = false
    ax.xlabelvisible = false
    ax.ylabelvisible = false
    ax.zlabelvisible = false
    ax.xgridvisible = false
    ax.ygridvisible = false
    ax.zgridvisible = false
    ax.xticksvisible = false
    ax.yticksvisible = false
    ax.zticksvisible = false
end

function color_box(ax, color)
    ax.xspinecolor_1 = color
    ax.yspinecolor_1 = color
    ax.zspinecolor_1 = color
    ax.xspinecolor_2 = color
    ax.yspinecolor_2 = color
    ax.zspinecolor_2 = color
    ax.xspinecolor_3 = color
    ax.yspinecolor_3 = color
    ax.zspinecolor_3 = color
    ax.xtickcolor = color
    ax.ytickcolor = color
    ax.ztickcolor = color
    ax.xticklabelcolor = color
    ax.yticklabelcolor = color
    ax.zticklabelcolor = color
    ax.xlabelcolor = color
    ax.ylabelcolor = color
    ax.zlabelcolor = color
    ax.xgridcolor = color
    ax.ygridcolor = color
    ax.zgridcolor = color
end


function primary_resolution()
    monitor = GLMakie.GLFW.GetPrimaryMonitor() 
    videomode = GLMakie.MonitorProperties(monitor).videomode 
    return (convert(Int64, videomode.width), convert(Int64, videomode.height)) 
end
