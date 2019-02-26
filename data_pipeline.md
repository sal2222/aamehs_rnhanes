data\_pipeline
================
Team LSD: Adnan, Jenni, Stephen
February 26, 2019

-   [Load and Merge Data](#load-and-merge-data)
    -   [PFAS Data](#pfas-data)
    -   [Body Mass Data](#body-mass-data)
    -   [Water Data](#water-data)
    -   [Merge Data](#merge-data)

Load and Merge Data
-------------------

### PFAS Data

``` r
pfas_data_clean = nhanes_load_data("PFAS_I", "2015-2016", demographics = TRUE) %>% 
  janitor::clean_names() %>% 
  select(seqn, cycle, sddsrvyr, riagendr, ridageyr, ridreth3, dmdeduc3, dmdeduc2, wtint2yr, wtmec2yr, lbxpfde:lbdmfosl) %>% 
  rename(pfdea = lbxpfde, pfhxs = lbxpfhs, me_pfosa_acoh = lbxmpah, pfna = lbxpfna, pfua = lbxpfua, pfdoa = lbxpfdo, n_pfoa = lbxnfoa,  sb_pfoa = lbxbfoa, n_pfos = lbxnfos,    sm_pfos = lbxmfos)
```

    ## Downloading PFAS_I.XPT to C:\Users\jenni\AppData\Local\Temp\RtmpQ9yaVg/PFAS_I.XPT

    ## Downloading DEMO_I.XPT to C:\Users\jenni\AppData\Local\Temp\RtmpQ9yaVg/DEMO_I.XPT

    ## Caching CSV to C:\Users\jenni\AppData\Local\Temp\RtmpQ9yaVg/DEMO_I.csv

### Body Mass Data

``` r
bodymass_data_clean <- nhanes_load_data("BMX_I", "2015-2016", demographics = TRUE) %>% 
  janitor::clean_names() %>% 
  select(seqn, bmxbmi, bmxwt, bmiwt)
```

    ## Downloading BMX_I.XPT to C:\Users\jenni\AppData\Local\Temp\RtmpQ9yaVg/BMX_I.XPT

### Water Data

``` r
# Day 1 
dietary_day1 <- nhanes_load_data("DR1TOT_I", "2015-2016") %>% 
    select(SEQN, DR1_320Z, DR1_330Z, DR1BWATZ, DR1TWS) %>% 
  janitor::clean_names() 
```

    ## Downloading DR1TOT_I.XPT to C:\Users\jenni\AppData\Local\Temp\RtmpQ9yaVg/DR1TOT_I.XPT

``` r
# Day 2
dietary_day2 <- nhanes_load_data("DR2TOT_I", "2015-2016") %>% 
    select(SEQN, DR2_320Z, DR2_330Z, DR2BWATZ, DR2TWS) %>% 
  janitor::clean_names()
```

    ## Downloading DR2TOT_I.XPT to C:\Users\jenni\AppData\Local\Temp\RtmpQ9yaVg/DR2TOT_I.XPT

``` r
# Merge 2 dietary recalls
water_data_clean <- 
  pfas_data_clean %>% 
  select(seqn) %>% 
  left_join(dietary_day1,  by = "seqn") %>% 
  left_join(dietary_day2,  by = "seqn") %>% 
  mutate(avg_320z = (dr1_320z + dr2_320z) / 2,
         avg_330z = (dr1_330z + dr2_320z) / 2,
         avgbwatz = (dr1bwatz + dr2bwatz) / 2)
```

### Merge Data

``` r
# Merge all data
aamehs_data = pfas_data_clean %>% 
  left_join(bodymass_data_clean, by = "seqn") %>% 
  left_join(water_data_clean, by = "seqn")

# Clean environment
rm(bodymass_data_clean, dietary_day1, dietary_day2, pfas_data_clean, water_data_clean)

# Save out final dataset??
```
