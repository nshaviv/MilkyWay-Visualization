using Random
using Distributions

function rot_period(r)
    240.0 * (max(r, 4) / 8)
end

function amp_r(r, rin, rout; smooth = 1)
    (tanh((r - rin) / smooth) - tanh((r - rout) / smooth))/2.0 
end

function pop_locations_at_time!(time, pop)
    Δphases = []
    phase = pop.Φ0s .+ (2π * time) ./ rot_period.(pop.r0s)
    arm_phases = []
    for set ∈ arm_sets
        arm_phase = - log.(4.0 .+ pop.r0s) / set.arm_pitch .+ 2π * time / 600.0
        arm_amp = map(r->amp_r(r, set.rin, set.rout), pop.r0s)
        Δphase = cos.(set.arm_num .* (phase .- arm_phase)) .* set.arm_phase_amp .* arm_amp 
        push!(Δphases, Δphase)
        push!(arm_phases, arm_phase)
    end
    arm_rot = 2π * time / arm_sets[1].period * frame_arm
    Δphase = sum(Δphases)
    r = pop.r0s .+ pop.amp_r .* sin.(Δphase .+ pop.phase_r)
    x = r .* cos.(phase .+ Δphase .- arm_rot)
    y = r .* sin.(phase .+ Δphase .- arm_rot)
    z = pop.z0s .* sin.(pop.zϕ0s .+ time*2*π / z_period)

    if pop.lifes[1] < 0
        return (x, y, z)
    end

    for i ∈ 1:pop.num
        if time > pop.lifes[i] + pop.birth_times[i]
            pop.birth_times[i] = time
            pop.Φ0s[i] = pop.phi_reset + arm_phases[1][i] - π/2*rand([0,1,2,3]) - 
                    time*2π ./ rot_period(pop.r0s[i]) + pop.phi_reset_amp*randn()*π/2
            pop.lifes[i] = pop.life_min .+ rand()*(pop.life_end - pop.life_min)
        end
    end

    if pop.type == 1
        return (x, y, z)
    end

    xk = [pop.Δx[i] .+ x[pop.parent_cluster[i]] for i ∈ 1:pop.num_kids]
    yk = [pop.Δy[i] .+ y[pop.parent_cluster[i]] for i ∈ 1:pop.num_kids]
    zk = [pop.Δz[i] .+ z[pop.parent_cluster[i]] for i ∈ 1:pop.num_kids]

    return(xk, yk, zk)
end 

function init_physics()
    for pop ∈ pops
        # If the object is a test particle, we only need
        # to set the initial position of it (e.g., the sun)
        if pop.type == 3 # Test particle / solar system
            append!(pop.r0s, [pop.sun_r])
            append!(pop.Φ0s, [pop.sun_ϕ])
            append!(pop.z0s, [pop.sun_z])
            append!(pop.zϕ0s, [0.0])
            append!(pop.lifes, [-1.0])
            append!(pop.birth_times, -1.0)
            continue 
        end 
        if pop.type == 4 # Bulge
            buldge_xs = randn(pop.num)*pop.x_scale
            buldge_ys = randn(pop.num)*pop.y_scale
            buldge_zs = randn(pop.num)*pop.z_scale
            append!(pop.r0s, sqrt.(buldge_xs.^2 .+ buldge_ys.^2))
            append!(pop.Φ0s, atan.(buldge_ys, buldge_xs))
            append!(pop.z0s, buldge_zs)
            append!(pop.zϕ0s, 2π * rand(pop.num))
            append!(pop.lifes, -1.0*ones(pop.num))
            append!(pop.birth_times, -1.0*ones(pop.num))
            c1 = pop.color_ranges[1]
            c2 = pop.color_ranges[2]
            m1 = pop.marker_size[1]
            m2 = pop.marker_size[2]
            append!(pop.colors, [RGB((c1 + rand() * (c2 - c1))...) for i = 1:pop.num])
            append!(pop.marker_sizes, [m1 + rand() * (m2 - m1) for i = 1:pop.num])
            continue 
        end
        # Otherwise, we generate a distribution and set the initial
        # positions of the objects / stars according to it
        dist = truncated(Chisq(pop.ν); upper=pop.rad_trunc / pop.rad_scale)
        append!(pop.r0s, pop.rad_scale * rand(dist, pop.num))
        append!(pop.Φ0s, 2π * rand(pop.num))
        append!(pop.z0s, pop.z_scale * randn(pop.num))
        append!(pop.zϕ0s, 2π * rand(pop.num))
        if pop.life_min < 0
            append!(pop.lifes, [-1.0])
            append!(pop.birth_times, -1.0)
        else
            append!(pop.lifes, pop.life_min .+ rand(pop.num) .* (pop.life_end - pop.life_min))
            append!(pop.birth_times, zeros(pop.num))
        end
        # If the object isn't clustered, we set the colors and marker sizes
        # Of the main objects in the population
        if pop.type == 1 || pop.type == 4 # population without clustering
            c1 = pop.color_ranges[1]
            c2 = pop.color_ranges[2]
            m1 = pop.marker_size[1]
            m2 = pop.marker_size[2]
            append!(pop.colors, [RGB((c1 + rand() * (c2 - c1))...) for i = 1:pop.num])
            append!(pop.marker_sizes, [m1 + rand() * (m2 - m1) for i = 1:pop.num])
        end
        if pop.type == 2 # population with clustering
            c1 = pop.color_ranges[1]
            c2 = pop.color_ranges[2]
            m1 = pop.marker_size[1]
            m2 = pop.marker_size[2]
            append!(pop.colors, [RGB((c1 + rand() * (c2 - c1))...) for i = 1:pop.num_kids])
            append!(pop.marker_sizes, [m1 + rand() * (m2 - m1) for i = 1:pop.num_kids])
            append!(pop.Δx, pop.cluster_r .* randn(pop.num_kids))
            append!(pop.Δy, pop.cluster_r .* randn(pop.num_kids))
            append!(pop.Δz, pop.cluster_r .* randn(pop.num_kids))
            append!(pop.parent_cluster, kid_to_parent(pop.num_kids, pop.num; power = pop.cluster_power))
            append!(pop.stars_start, rand(pop.num_kids)*0.2 )
            append!(pop.stars_end, rand(pop.num_kids)*0.5 .+ 0.5)
            append!(pop.cluster_rs, pop.cluster_r .* exp.(randn(pop.num)))
            append!(pop.alpha_stars, pop.α .* ones(pop.num_kids))    
        end
    end
    return nothing
end

# This function generates a realization linking stars to their parent clusters
# power = 1 implies homogeneous clusters. The larger the power, the larger the
# GINI index ;-) 
function kid_to_parent(nkids, nparent; power = 1.5)
    (Int64.(floor.( sort(rand(nkids)).^power*nparent .+ 1 )))
end

sum([ [1,2,3], [3,4,5]])