data(s14MM_v1)


# test sampling
plot_path_density_filled(s14MM_v1, bins = 10, GOF_rank = 10, samples = 1, replace = FALSE, show.legend = FALSE)

plot_path_density_filled(s14MM_v1, bins = 10, GOF_rank = 10, samples = 1, replace = TRUE, show.legend = FALSE)

plot_path_density_filled(s14MM_v1, bins = 10, GOF_rank = 10, samples = 10, replace = TRUE, show.legend = FALSE)

plot_path_density_filled(s14MM_v1, bins = 10, GOF_rank = 10, samples = 100, replace = TRUE, show.legend = FALSE)

plot_path_density_filled(s14MM_v1, bins = 10, GOF_rank = 10, samples = 1000, show.legend = FALSE)

# test gof
plot_path_density_filled(s14MM_v1, bins = 10, GOF_rank = 1, samples = 100, show.legend = FALSE)

plot_path_density_filled(s14MM_v1, bins = 10, GOF_rank = 10, samples = 100, show.legend = FALSE)

plot_path_density_filled(s14MM_v1, bins = 10, GOF_rank = 1, samples = 100, show.legend = FALSE)

plot_path_density_filled(s14MM_v1, bins = 10, GOF_rank = 100, samples = 100, show.legend = FALSE)
