# Source all the things
source("R/functions.R")

size_data <- read_csv(here("data/size_data.csv"))
bw <- 0.2

bd_size_gg <- size_hist(size_data, bw = bw, 
                        title = expression(paste("D. Crab burrows")))

uca_size_gg <- size_data %>%
  filter(variable != "burrow_diameter") %>%
  size_hist(xlab = "Carapace width (cm)", "uca_carapace", backdrop = TRUE, 
            bw = bw, 
            title = expression(paste("A. ", italic("Uca"), "spp.")))

carcinus_size_gg <- size_data %>%
  filter(variable != "burrow_diameter") %>%
  size_hist(xlab = "Carapace width (cm)", "carcinus_carapace", backdrop = TRUE, 
            bw = bw, 
            title = expression(paste("B. ", italic("Carcinus maenas"))))

sesarma_size_gg <- size_data %>%
  filter(variable != "burrow_diameter") %>%
  size_hist(xlab = "Carapace width (cm)", "sesarma_carapace", backdrop = TRUE, 
            bw = bw, 
            title = expression(paste("C. ", italic("Sesarma reticulatum"))))

jpeg("figures/size_fig.jpg", width = 7.5, height = 10, units = "in", 
     res=300)
multiplot(uca_size_gg,carcinus_size_gg, sesarma_size_gg, bd_size_gg, cols = 1)
dev.off()
