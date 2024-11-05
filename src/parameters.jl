begin
  # Visualization parameters
  frame_draw = false        # Should we draw a frame?
  frame_color = :red       # If so, which color?
  frame_arm = 0            # 0 for lab frame, 1 for co-rotaton with arm #1

  size_scale = 1.0         # scale marker size

  # Arm parameters
  # no of sets of arms

  arm_sets = []

  # Set #1 - 4 arms
  push!(arm_sets,
    (
      arm_num=4,            # Number of arms
      arm_phase_0=0.0,      # Phase of arms
      arm_phase_amp=0.14,   # amplitude of arm phase (larger = more pronounced arms)
      arm_pitch=0.25,       # dimensionless pitch (tan of angle)
      rin=8.0,              # Inner radius of arms
      rout=24.0,            # Outer radius of arms
      period = 600.0        # Rotation period of the arms
    ))
  if true # Set #2 - 2 arms
    push!(arm_sets,
      (
        arm_num=2,            # Number of arms
        arm_phase_0=0.0,      # Phase of arms
        arm_phase_amp=0.14,   # amplitude of arm phase (larger = more pronounced arms)
        arm_pitch=0.25,       # dimensionless pitch (tan of angle)
        rin=4.0,              # Inner radius of arms
        rout=40.0,            # Outer radius of arms
        period = 240.0        # Rotation period of the arms
      ))
  end

  # z-orbit parameters
  z_period = 64.0          # Period of z orbit in Myr (fixed for the whole milky way)
  num_z_orbits = 4.0

  # Different type of populations
  # 1 - population with no clustering. 
  # 2 - population with clustering
  # 3 - Test particle (e.g., solar system)
  # 4 - Bulge population

  pops = []

  # Population 1 - Background Stars (points)

  push!(pops,
    (
      label="Field Stars - smooth - dim",
      type=1,               # Population without clustering
      num=10000,              # Number of stars
      life_min=-1,            # Minimum life of stars (negative means infinite)
      rad_scale=3.5,
      rad_trunc=37.0,
      ν=5.0,                # chi^2 distribution parameter (4 gives uniform distribution at small radii. > gives less stars at small radii)
      z_scale=1.0,            # scale height of the population
      amp_r=0.0,              # amplitude of radial oscillation
      phase_r=π,              # phase of radial oscillation
      α=0.005,                 # transparency of the obects (nebolous objects have low alpha and large marker size)
      marker_size=(60.0, 80.0),                          # rand of size of the markers
      color_ranges=([249, 241 * 0.8, 194 * 0.8], [249, 241, 194]) ./ 256, # color ranges for the population
      add_glare=false,       # Add glare to the stars (i.e., add a glow around objects)
      mesh=false,              # mesh scatter plot?
      r0s=[],               # Initial radii of the stars
      Φ0s=[],               # Initial phases of the stars
      z0s=[],               # Initial z positions of the stars
      zϕ0s=[],              # Initial z phases of the stars
      lifes=[],             # Lifetimes of the stars
      birth_times=[],       # Birth times of the stars
      colors=[],            # Colors of the stars
      marker_sizes=[],      # Marker sizes of the stars     
    ))

  push!(pops,
    (
      label="Field Stars - smooth - medium",
      type=1,               # Population without clustering
      num=18000,              # Number of stars
      life_min=-1,            # Minimum life of stars (negative means infinite)
      rad_scale=2.5,
      rad_trunc=37.0,
      ν=5.0,                # chi^2 distribution parameter (4 gives uniform distribution at small radii. > gives less stars at small radii)
      z_scale=1.0,            # scale height of the population
      amp_r=0.0,              # amplitude of radial oscillation
      phase_r=π,              # phase of radial oscillation
      α=0.01,                 # transparency of the obects (nebolous objects have low alpha and large marker size)
      marker_size=(20.0, 30.0),                          # rand of size of the markers
      color_ranges=([1.0, 1.0, 1.0], [1.0, 1.0, 1.0]), # color ranges for the population
      add_glare=false,       # Add glare to the stars (i.e., add a glow around objects)
      mesh=false,              # mesh scatter plot?
      r0s=[],               # Initial radii of the stars
      Φ0s=[],               # Initial phases of the stars
      z0s=[],               # Initial z positions of the stars
      zϕ0s=[],              # Initial z phases of the stars
      lifes=[],             # Lifetimes of the stars
      birth_times=[],       # Birth times of the stars
      colors=[],            # Colors of the stars
      marker_sizes=[],      # Marker sizes of the stars     
    ))

  push!(pops,
    (
      label="Field Stars - points",
      type=1,               # Population without clustering
      num=500,              # Number of stars
      life_min=-1,            # Minimum life of stars (negative means infinite)
      rad_scale=3.5,
      rad_trunc=47.0,
      ν=5.0,                # chi^2 distribution parameter (4 gives uniform distribution at small radii. > gives less stars at small radii)
      z_scale=1.0,            # scale height of the population
      amp_r=0.0,              # amplitude of radial oscillation
      phase_r=π,              # phase of radial oscillation
      α=1.0,                 # transparency of the obects (nebolous objects have low alpha and large marker size)
      marker_size=(1.0, 3.0),                          # rand of size of the markers
      color_ranges=([1.0, 1.0, 1.0], [1.0, 1.0, 1.0]), # color ranges for the population
      add_glare=true,       # Add glare to the stars (i.e., add a glow around objects)
      mesh=false,              # mesh scatter plot?
      r0s=[],               # Initial radii of the stars
      Φ0s=[],               # Initial phases of the stars
      z0s=[],               # Initial z positions of the stars
      zϕ0s=[],              # Initial z phases of the stars
      lifes=[],             # Lifetimes of the stars
      birth_times=[],       # Birth times of the stars
      colors=[],            # Colors of the stars
      marker_sizes=[],      # Marker sizes of the stars     
    ))

  push!(pops,
    (
      label="Field Stars - points small",
      type=1,               # Population without clustering
      num=800,              # Number of stars
      life_min=-1,            # Minimum life of stars (negative means infinite)
      rad_scale=3.5,
      rad_trunc=47.0,
      ν=5.0,                # chi^2 distribution parameter (4 gives uniform distribution at small radii. > gives less stars at small radii)
      z_scale=1.5,            # scale height of the population
      amp_r=0.0,              # amplitude of radial oscillation
      phase_r=π,              # phase of radial oscillation
      α=0.6,                 # transparency of the obects (nebolous objects have low alpha and large marker size)
      marker_size=(0.5, 1.0),                          # rand of size of the markers
      color_ranges=([1.0, 1.0, 1.0], [1.0, 0.8, 0.8]), # color ranges for the population
      add_glare=true,       # Add glare to the stars (i.e., add a glow around objects)
      mesh=false,              # mesh scatter plot?
      r0s=[],               # Initial radii of the stars
      Φ0s=[],               # Initial phases of the stars
      z0s=[],               # Initial z positions of the stars
      zϕ0s=[],              # Initial z phases of the stars
      lifes=[],             # Lifetimes of the stars
      birth_times=[],       # Birth times of the stars
      colors=[],            # Colors of the stars
      marker_sizes=[],      # Marker sizes of the stars     
    ))


  push!(pops,
    (
      label="Blue Stars - stars",
      type=2,               # Population with clustering
      num=150,              # Number objects (clusters)
      num_kids=2000,          # Total number of stars > num 
      life_min=10,            # Minimum life of stars (negative means infinite)
      life_end=30,            # Maximum life of stars
      phi_reset=π / 2 / 4,       # phase reset of the population
      phi_reset_amp=0.2,      # phase reset amplitude of the population
      rad_scale=4.5,
      rad_trunc=37.0,
      ν=5.0,                # chi^2 distribution parameter (4 gives uniform distribution at small radii. > gives less stars at small radii)
      z_scale=0.2,            # scale height of the population
      amp_r=0.0,              # amplitude of radial oscillation
      phase_r=π,              # phase of radial oscillation
      α=0.7,                 # transparency of the obects (nebolous objects have low alpha and large marker size)
      marker_size=(1.0, 4.0),                          # rand of size of the markers
      color_ranges=([0.1, 0.2, 1.0], [0.2, 0.3, 1.0]), # color ranges for the population
      add_glare=true,       # Add glare to the stars (i.e., add a glow around objects)
      mesh=false,              # mesh scatter plot?
      r0s=[],               # Initial radii of the clusters
      Φ0s=[],               # Initial phases of the clusters
      z0s=[],               # Initial z positions of clusters
      zϕ0s=[],              # Initial z phases of the clusters
      lifes=[],             # Lifetimes of the clusters
      birth_times=[],       # Birth times of the clusters
      colors=[],            # Colors of the stars
      marker_sizes=[],      # Marker sizes of the stars
      parent_cluster=[],    # The parent cluster of the stars     
      alpha_stars=[],       # transparency of the stars
      stars_start=[],       # fraction of cluster life that the stars ignite
      stars_end=[],         # fraction of cluster life that the stars end
      Δx=[],                # x offset of the stars
      Δy=[],                # y offset of the stars
      Δz=[],                # z offset of the stars
      cluster_rs=[],         # radius of actual cluster_rs
      cluster_r=0.3,         # mean radius of cluster (kpc)
      cluster_power=0.5   # 1 => on average same number of stars in each cluster, >1 or <1 gives a distribution in the number of stars
    ))


  push!(pops,
    (
      label="Red Clusters - stars",
      type=2,               # Population with clustering
      num=150,              # Number objects (clusters)
      num_kids=1000,          # Total number of stars > num 
      life_min=10,            # Minimum life of stars (negative means infinite)
      life_end=30,            # Maximum life of stars
      phi_reset=π / 2 / 4,       # phase reset of the population
      phi_reset_amp=0.2,      # phase reset amplitude of the population
      rad_scale=6.5,
      rad_trunc=37.0,
      ν=5.0,                # chi^2 distribution parameter (4 gives uniform distribution at small radii. > gives less stars at small radii)
      z_scale=0.2,            # scale height of the population
      amp_r=0.0,              # amplitude of radial oscillation
      phase_r=π,              # phase of radial oscillation
      α=0.05,                 # transparency of the obects (nebolous objects have low alpha and large marker size)
      marker_size=(5.0, 20.0),                          # rand of size of the markers
      color_ranges=([255, 92, 163], [245, 20, 117]) ./ 255, # color ranges for the population
      add_glare=true,       # Add glare to the stars (i.e., add a glow around objects)
      mesh=false,              # mesh scatter plot?
      r0s=[],               # Initial radii of the clusters
      Φ0s=[],               # Initial phases of the clusters
      z0s=[],               # Initial z positions of clusters
      zϕ0s=[],              # Initial z phases of the clusters
      lifes=[],             # Lifetimes of the clusters
      birth_times=[],       # Birth times of the clusters
      colors=[],            # Colors of the stars
      marker_sizes=[],      # Marker sizes of the stars
      parent_cluster=[],    # The parent cluster of the stars     
      alpha_stars=[],       # transparency of the stars
      stars_start=[],       # fraction of cluster life that the stars ignite
      stars_end=[],         # fraction of cluster life that the stars end
      Δx=[],                # x offset of the stars
      Δy=[],                # y offset of the stars
      Δz=[],                # z offset of the stars
      cluster_rs=[],         # radius of actual cluster_rs
      cluster_r=0.3,         # mean radius of cluster (kpc)
      cluster_power=0.5   # 1 => on average same number of stars in each cluster, >1 or <1 gives a distribution in the number of stars
    ))

  push!(pops,
    (
      label="Bulge",
      type=4,               # Population without clustering
      num=2000,              # Number of stars
      life_min=-1,            # Minimum life of stars (negative means infinite)
      rad_scale=3.5,
      rad_trunc=37.0,
      ν=5.0,                # chi^2 distribution parameter (4 gives uniform distribution at small radii. > gives less stars at small radii)
      x_scale=6.0,
      y_scale=5.0,
      z_scale=2.5,            # scale height of the population
      amp_r=0.0,              # amplitude of radial oscillation
      phase_r=π,              # phase of radial oscillation
      α=0.0075,                 # transparency of the obects (nebolous objects have low alpha and large marker size)
      marker_size=(100.0, 100.0),                          # rand of size of the markers
      color_ranges=([0.9, 0.65, 0.2], [0.9, 0.65, 0.2]), # color ranges for the population
      add_glare=false,       # Add glare to the stars (i.e., add a glow around objects)
      mesh=false,              # mesh scatter plot?
      r0s=[],               # Initial radii of the stars
      Φ0s=[],               # Initial phases of the stars
      z0s=[],               # Initial z positions of the stars
      zϕ0s=[],              # Initial z phases of the stars
      lifes=[],             # Lifetimes of the stars
      birth_times=[],       # Birth times of the stars
      colors=[],            # Colors of the stars
      marker_sizes=[],      # Marker sizes of the stars     
    ))

  push!(pops,
    (label="Sun",
      type=3,
      num=1,
      sun_r=8.0,
      sun_ϕ=0.0,
      sun_z=1.15,
      amp_r=2.5,
      phase_r=π,
      alpha=1.0,
      marker_size=10,
      color_ranges=([1.0, 1.0, 0.0], [1.0, 1.0, 0.0]),
      r0s=[],               # Initial radii of the stars
      Φ0s=[],               # Initial phases of the stars
      z0s=[],               # Initial z positions of the stars
      zϕ0s=[],
      lifes=[],             # Lifetimes of the stars
      birth_times=[],       # Birth times of the stars
    ))


end

