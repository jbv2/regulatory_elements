## Load libraries
library("ggplot2")
library("dplyr")
library ("tidyr")

#starting args object to recieve arguments from command line
#solution taken from https://www.r-bloggers.com/passing-arguments-to-an-r-script-from-command-lines/
args = commandArgs(trailingOnly = T )
message("Voy a imprimir los archivos recibidos por R")
print(args)

# For Debbuging only
# Comentar estas líneas cuando el script pase a producción
#args[1] is the tsv  file
args[1] <- "test/data/sample_GH_variants.filtered.tsv"
#args[2] is the length of REs reference file
args[2] <- "test/reference/lenght_of_REs.tsv"
#args[3] is the target file (expected output file)
args[3] <- "test/data/sample_GH_variants.filtered.summary.tsv"

## Define input and outputs
input_file <- args[1]
length_reference_file <- args[2]
output_file <- args[3]

## Load data frame
GH_variants.df <- read.table(file = input_file, 
                             header = T, sep = "\t")

## Data handling
# select only useful columns
genehancer_data.df <- GH_variants.df %>% 
  select(ID,
         GeneHancer_type_and_Genes)
# separate genehancer column 
split_cols_genehancer_data.df <- genehancer_data.df %>% 
  separate(col = GeneHancer_type_and_Genes, 
           into = c("GeneHancerID", "Type", "Gene"), 
           sep = "_", 
           remove = T)

# count the number of variants per GeneHancerID
variants_per_GeneHancerID.df <- split_cols_genehancer_data.df %>% 
  group_by(GeneHancerID) %>% 
  summarise( number_of_variants = n() 
             )

# count the number of variants per Gene
variants_per_Gene.df <- split_cols_genehancer_data.df %>% 
  group_by(Gene) %>% #Forma subgrupos sobre los que se va a operar (group_by)
  summarise( number_of_variants_per_gene = n() 
  )

## Calculate variant density per gene
normalized_variants_per_gene.df$variant_density_per_kb <- normalized_variants_per_gene.df$number_of_variants_per_gene / normalized_variants_per_gene.df$Lenght_of_REs_summarized * 1000 

## Loading reference length data
reference_lenght.df <- read.table(file = length_reference_file,
                                  header = T,
                                  sep = "\t",
                                  stringsAsFactors = F)

# Joinning RE length with Gene information
normalized_variants_per_gene.df <- merge(x = variants_per_Gene.df, y = reference_lenght.df, by = "Gene")

## Save output
write.table(x = variants_per_GeneHancerID.df, 
            file = output_file, 
            append = F, 
            quote = F, 
            sep = "\t", 
            row.names = F, 
            col.names = T)

# Make lolliplot plot
lolliplot.p <- ggplot(data = variants_per_GeneHancerID.df, 
       aes(x = GeneHancerID, 
           y = number_of_variants) 
       ) +
  geom_bar(stat = "identity", 
           width = 0.1, 
           color = "royalblue") +
  geom_point(size = 1, 
             color = "gray") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, 
                                   size = 5) 
        )

# Save lollipop plot
# Create dynamic name for output plot
output_lollipop_plot <- output_file %>% gsub(pattern = ".tsv", 
                     replacement = "_lollipop_plot.png")

#Save plot
ggsave(filename = output_lollipop_plot, 
       plot = lolliplot.p, 
       device = "png",
       width = 10.8,
       height = 7.2,
       units = "cm",
       dpi = 300)
