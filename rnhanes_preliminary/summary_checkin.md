summary\_checkin
================
Team LSD: Adnan, Jenni, Stephen
February 13, 2019

-   [Per- and polyfluoroalkyl substances (PFAS) and Body Mass](#per--and-polyfluoroalkyl-substances-pfas-and-body-mass)
    -   [26 February 2019 Check-In](#february-2019-check-in)
    -   [NHANES Dietary Interviews](#nhanes-dietary-interviews)
    -   [PFAS](#pfas)
        -   [Load and Inspect PFAS data](#load-and-inspect-pfas-data)
        -   [2015-2016 PFAS summary table](#pfas-summary-table)
    -   [Body Mass](#body-mass)
        -   [Load and Inspect BMI data](#load-and-inspect-bmi-data)
        -   [Inspect body mass data from 2015-2016](#inspect-body-mass-data-from-2015-2016)
    -   [Merged Dataset](#merged-dataset)
    -   [Water](#water)
        -   [Load water consumption](#load-water-consumption)
        -   [Water consumption table (PFAS sample)](#water-consumption-table-pfas-sample)
        -   [Water consumption boxplot](#water-consumption-boxplot)

Per- and polyfluoroalkyl substances (PFAS) and Body Mass
========================================================

26 February 2019 Check-In
-------------------------

``` r
library(tidyverse)
library(RNHANES)
library(survey)
```

    ## Warning: package 'survey' was built under R version 3.5.2

NHANES Dietary Interviews
-------------------------

*Reference*: <https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/DR1IFF_I.htm>

Detailed information about each food/beverage item (including the description, amount of, and nutrient content) reported by each participant is included in the Individual Foods files.

-   Drinking water variables:

    -   Total plain water drank yesterday (gm)
    -   Total tap water drank yesterday (gm)
    -   Total bottled water drank yesterday (gm)
    -   Tap water source

-   Fish consumption during past 30 days (by type)

PFAS
----

### Load and Inspect PFAS data

NHANES Codebook References: <https://wwwn.cdc.gov/Nchs/Nhanes/2013-2014/PFAS_H.htm> <https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/PFAS_I.htm>

``` r
pfas_load <- nhanes_load_data("PFAS_I", "2015-2016", demographics = TRUE)

pfas_survey <- nhanes_survey_design(pfas_load, "WTSB2YR")

pfas_data <- nhanes_load_data("PFAS_I", "2015-2016", demographics = TRUE) %>% 
  janitor::clean_names() %>% 
  rename(pfdea = lbxpfde, pfhxs = lbxpfhs, me_pfosa_acoh = lbxmpah, pfna = lbxpfna, pfua = lbxpfua, pfdoa = lbxpfdo, n_pfoa = lbxnfoa,  sb_pfoa = lbxbfoa, n_pfos = lbxnfos,    sm_pfos = lbxmfos)
```

### 2015-2016 PFAS summary table

``` r
#pfas_summary <-
#  pfas_data %>%
#    select(seqn, pfdea, pfhxs, me_pfosa_acoh,  pfna, pfua, pfdoa, n_pfoa, sb_pfoa, n_pfos, sm_pfos) %>% 
#    gather(key = "analyte", value = "value", pfdea:sm_pfos) %>% 
#    group_by(analyte) %>% 
#    na.omit() %>% 
#    summarise(n = n(), 
#              mean = mean(value),
#              sd = sd(value))


pfas_summary <-
  pfas_load %>%
    select(SEQN, LBXPFDE, LBXPFHS, LBXMPAH, LBXPFNA, LBXPFUA, LBXPFDO, LBXNFOA, LBXBFOA, LBXNFOS, LBXMFOS) %>% 
    gather(key = "variable", value = "value", LBXPFDE:LBXMFOS) %>% 
    group_by(variable) %>% 
    na.omit() %>% 
    summarise(n = n(), 
              mean = mean(value),
              sd = sd(value))


# Weighted

pfas_inputs <- as.data.frame(matrix(c(
  # CYCLE        COLUMN    COMMENT     WEIGHTS
   "2015-2016", "LBXPFDE", "LBDPFDEL", "WTSB2YR",
   "2015-2016", "LBXPFHS", "LBDPFHSL", "WTSB2YR",
   "2015-2016", "LBXMPAH", "LBDMPAHL", "WTSB2YR",
   "2015-2016", "LBXPFNA", "LBDPFNAL", "WTSB2YR",
   "2015-2016", "LBXPFUA", "LBDPFUAL", "WTSB2YR",
   "2015-2016", "LBXPFDO", "LBDPFDOL", "WTSB2YR",
   "2015-2016", "LBXNFOA", "LBDNFOAL", "WTSB2YR",
   "2015-2016", "LBXBFOA", "LBDBFOAL", "WTSB2YR",
   "2015-2016", "LBXNFOS", "LBDNFOSL", "WTSB2YR",
   "2015-2016", "LBXMFOS", "LBDMFOSL", "WTSB2YR"
), ncol = 4, byrow = TRUE), stringsAsFactors = FALSE)

names(pfas_inputs) <- c("cycle", "column", "comment_column", "weights_column")

weighted_median <-
  nhanes_quantile(pfas_load, pfas_inputs, quantiles = 0.5) %>% 
  select(column, weighted_median = value)
```

    ## Warning in callback(nhanes_data, ret): No detection limit found from the
    ## summary tables. Falling back to inferring detection limit from the fill
    ## value.

    ## Warning in callback(nhanes_data, ret): No detection limit found from the
    ## summary tables. Falling back to inferring detection limit from the fill
    ## value.

    ## Warning in callback(nhanes_data, ret): No detection limit found from the
    ## summary tables. Falling back to inferring detection limit from the fill
    ## value.

    ## Warning in callback(nhanes_data, ret): No detection limit found from the
    ## summary tables. Falling back to inferring detection limit from the fill
    ## value.

    ## Warning in callback(nhanes_data, ret): No detection limit found from the
    ## summary tables. Falling back to inferring detection limit from the fill
    ## value.

    ## Warning in callback(nhanes_data, ret): No detection limit found from the
    ## summary tables. Falling back to inferring detection limit from the fill
    ## value.

    ## Warning in callback(nhanes_data, ret): No detection limit found from the
    ## summary tables. Falling back to inferring detection limit from the fill
    ## value.

    ## Warning in callback(nhanes_data, ret): No detection limit found from the
    ## summary tables. Falling back to inferring detection limit from the fill
    ## value.

    ## Warning in callback(nhanes_data, ret): No detection limit found from the
    ## summary tables. Falling back to inferring detection limit from the fill
    ## value.

    ## Warning in callback(nhanes_data, ret): No detection limit found from the
    ## summary tables. Falling back to inferring detection limit from the fill
    ## value.

``` r
weighted_mean <-
  nhanes_survey(svymean, pfas_load, pfas_inputs, na.rm = TRUE) %>% 
    select(column, weighted_mean = value)




codes <- data.frame(
  variable = c("LBXPFDE", "LBXPFHS", "LBXMPAH", "LBXPFNA", "LBXPFUA", "LBXPFDO", "LBXNFOA", "LBXBFOA", "LBXNFOS", "LBXMFOS"),
  analyte = c("pfdea", "pfhxs", "me_pfosa_acoh",    "pfna", "pfua", "pfdoa", "n_pfoa", "sb_pfoa", "n_pfos", "sm_pfos"))


pfas_table <-
  pfas_summary %>% 
    left_join(weighted_mean, by = c("variable" = "column")) %>% 
    left_join(weighted_median, by = c("variable" = "column")) %>% 
    left_join(codes, by = "variable") %>% 
    subset(select = c(1, 7, 2, 3, 4, 5, 6))
```

    ## Warning: Column `variable` joining character vector and factor, coercing
    ## into character vector

``` r
pfas_table %>%
  knitr::kable(digits = 2) 
```

| variable | analyte         |     n|  mean|    sd|  weighted\_mean|  weighted\_median|
|:---------|:----------------|-----:|-----:|-----:|---------------:|-----------------:|
| LBXBFOA  | sb\_pfoa        |  1993|  0.07|  0.02|            0.07|              0.07|
| LBXMFOS  | sm\_pfos        |  1993|  1.94|  1.88|            2.05|              1.50|
| LBXMPAH  | me\_pfosa\_acoh |  1993|  0.17|  0.27|            0.17|              0.07|
| LBXNFOA  | n\_pfoa         |  1993|  1.81|  1.63|            1.90|              1.50|
| LBXNFOS  | n\_pfos         |  1993|  5.10|  6.84|            4.72|              3.20|
| LBXPFDE  | pfdea           |  1993|  0.26|  0.45|            0.24|              0.10|
| LBXPFDO  | pfdoa           |  1993|  0.07|  0.01|            0.07|              0.07|
| LBXPFHS  | pfhxs           |  1993|  1.61|  1.75|            1.74|              1.20|
| LBXPFNA  | pfna            |  1993|  0.78|  0.70|            0.76|              0.60|
| LBXPFUA  | pfua            |  1993|  0.16|  0.26|            0.14|              0.07|

Body Mass
---------

NHANES Codebook References: <https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/BMX_I.htm>

### Load and Inspect BMI data

``` r
bodymass_data <- nhanes_load_data("BMX_I", "2015-2016", demographics = TRUE)
as_tibble(bodymass_data)
```

    ## # A tibble: 9,544 x 76
    ##     SEQN cycle SDDSRVYR RIDSTATR RIAGENDR RIDAGEYR RIDAGEMN RIDRETH1
    ##    <int> <chr>    <int>    <int>    <int>    <int>    <int>    <int>
    ##  1 83732 2015~        9        2        1       62       NA        3
    ##  2 83733 2015~        9        2        1       53       NA        3
    ##  3 83734 2015~        9        2        1       78       NA        3
    ##  4 83735 2015~        9        2        2       56       NA        3
    ##  5 83736 2015~        9        2        2       42       NA        4
    ##  6 83737 2015~        9        2        2       72       NA        1
    ##  7 83738 2015~        9        2        2       11       NA        1
    ##  8 83739 2015~        9        2        1        4       NA        3
    ##  9 83740 2015~        9        2        1        1       13        2
    ## 10 83741 2015~        9        2        1       22       NA        4
    ## # ... with 9,534 more rows, and 68 more variables: RIDRETH3 <int>,
    ## #   RIDEXMON <int>, RIDEXAGM <int>, DMQMILIZ <int>, DMQADFC <int>,
    ## #   DMDBORN4 <int>, DMDCITZN <int>, DMDYRSUS <int>, DMDEDUC3 <int>,
    ## #   DMDEDUC2 <int>, DMDMARTL <int>, RIDEXPRG <int>, SIALANG <int>,
    ## #   SIAPROXY <int>, SIAINTRP <int>, FIALANG <int>, FIAPROXY <int>,
    ## #   FIAINTRP <int>, MIALANG <int>, MIAPROXY <int>, MIAINTRP <int>,
    ## #   AIALANGA <int>, DMDHHSIZ <int>, DMDFMSIZ <int>, DMDHHSZA <int>,
    ## #   DMDHHSZB <int>, DMDHHSZE <int>, DMDHRGND <int>, DMDHRAGE <int>,
    ## #   DMDHRBR4 <int>, DMDHREDU <int>, DMDHRMAR <int>, DMDHSEDU <int>,
    ## #   WTINT2YR <dbl>, WTMEC2YR <dbl>, SDMVPSU <int>, SDMVSTRA <int>,
    ## #   INDHHIN2 <int>, INDFMIN2 <int>, INDFMPIR <dbl>, BMDSTATS <dbl>,
    ## #   BMXWT <dbl>, BMIWT <dbl>, BMXRECUM <dbl>, BMIRECUM <dbl>,
    ## #   BMXHEAD <dbl>, BMIHEAD <dbl>, BMXHT <dbl>, BMIHT <dbl>, BMXBMI <dbl>,
    ## #   BMDBMIC <dbl>, BMXLEG <dbl>, BMILEG <dbl>, BMXARML <dbl>,
    ## #   BMIARML <dbl>, BMXARMC <dbl>, BMIARMC <dbl>, BMXWAIST <dbl>,
    ## #   BMIWAIST <dbl>, BMXSAD1 <dbl>, BMXSAD2 <dbl>, BMXSAD3 <dbl>,
    ## #   BMXSAD4 <dbl>, BMDAVSAD <dbl>, BMDSADCM <dbl>, file_name <chr>,
    ## #   begin_year <dbl>, end_year <dbl>

### Inspect body mass data from 2015-2016

``` r
# bodymass_data %>%  nhanes_detection_frequency("BMXBMI", "BMXBMI", "WTMEC2YR") # not completely sure on weight
bodymass_data %>% nhanes_sample_size("BMXBMI", "BMXBMI", "WTMEC2YR")
```

    ##   value     cycle begin_year end_year file_name column weights_column
    ## 1  8756 2015-2016       2015     2016     BMX_I BMXBMI       WTMEC2YR
    ##   comment_column        name
    ## 1         BMXBMI sample size

``` r
bodymass_data %>%  nhanes_quantile("BMXBMI","BMXBMI", "WTMEC2YR", quantiles = c(0.5, 0.95))
```

    ##   value     cycle begin_year end_year file_name column weights_column
    ## 1  26.6 2015-2016       2015     2016     BMX_I BMXBMI       WTMEC2YR
    ## 2  41.3 2015-2016       2015     2016     BMX_I BMXBMI       WTMEC2YR
    ##   comment_column below_lod quantile     name
    ## 1         BMXBMI     FALSE      50% quantile
    ## 2         BMXBMI     FALSE      95% quantile

Merged Dataset
--------------

``` r
pfas_data_clean = nhanes_load_data("PFAS_I", "2015-2016", demographics = TRUE) %>% 
  janitor::clean_names() %>% 
  select(seqn, cycle, sddsrvyr, riagendr, ridageyr, ridreth3, dmdeduc3, dmdeduc2, wtint2yr, wtmec2yr, lbxpfde:lbdmfosl) %>% 
  rename(pfdea = lbxpfde, pfhxs = lbxpfhs, me_pfosa_acoh = lbxmpah, pfna = lbxpfna, pfua = lbxpfua, pfdoa = lbxpfdo, n_pfoa = lbxnfoa,  sb_pfoa = lbxbfoa, n_pfos = lbxnfos,    sm_pfos = lbxmfos)

bodymass_data_clean = bodymass_data %>% 
  janitor::clean_names() %>% 
  select(seqn, bmxbmi, bmxwt, bmiwt)

pfas_bodymass_clean = left_join(pfas_data_clean, bodymass_data_clean, by = "seqn")
```

``` r
# Histogram of BMI

pfas_bodymass_clean %>% 
  ggplot(aes(x = bmxbmi)) +
  geom_histogram()
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 23 rows containing non-finite values (stat_bin).

![](summary_checkin_files/figure-markdown_github/unnamed-chunk-2-1.png)

``` r
# Histogram of Weight

pfas_bodymass_clean %>% 
  ggplot(aes(x = bmxwt)) +
  geom_histogram()
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 23 rows containing non-finite values (stat_bin).

![](summary_checkin_files/figure-markdown_github/unnamed-chunk-2-2.png)

``` r
# Descriptive statistics BMI and weight

stats_bmi = as_data_frame(
  summarise(pfas_bodymass_clean,
            Mean = mean(bmxbmi, na.rm = TRUE),
            SD = sd(bmxbmi, na.rm = TRUE),
            Median = median(bmxbmi, na.rm = TRUE),
            IQR = IQR(bmxbmi, na.rm = TRUE))
  ) %>% 
  mutate(Variable = c("BMI"))

stats_wt = as_data_frame(
  summarise(pfas_bodymass_clean,
            Mean = mean(bmxwt, na.rm = TRUE),
            SD = sd(bmxwt, na.rm = TRUE),
            Median = median(bmxwt, na.rm = TRUE),
            IQR = IQR(bmxwt, na.rm = TRUE))
  ) %>% 
  mutate(Variable = c("Weight"))

bodymass_table = stats_bmi %>% 
  bind_rows(., stats_wt) %>% 
  subset(select = c("Variable", "Mean", "SD", "Median", "IQR")) 

bodymass_table %>% 
  knitr::kable()
```

| Variable |      Mean|         SD|  Median|    IQR|
|:---------|---------:|----------:|-------:|------:|
| BMI      |  28.66707|   7.148769|    27.7|   9.00|
| Weight   |  79.24974|  22.403440|    76.1|  28.05|

Water
-----

### Load water consumption

``` r
dietary_day1 <- nhanes_load_data("DR1TOT_I", "2015-2016") %>% 
    select(SEQN, DR1_320Z, DR1_330Z, DR1BWATZ, DR1TWS) %>% 
  janitor::clean_names() 
```

    ## Downloading DR1TOT_I.XPT to C:\Users\slewa\AppData\Local\Temp\RtmpIV3YaV/DR1TOT_I.XPT

``` r
dietary_day2 <- nhanes_load_data("DR2TOT_I", "2015-2016") %>% 
    select(SEQN, DR2_320Z, DR2_330Z, DR2BWATZ, DR2TWS) %>% 
  janitor::clean_names()
```

    ## Downloading DR2TOT_I.XPT to C:\Users\slewa\AppData\Local\Temp\RtmpIV3YaV/DR2TOT_I.XPT

#### Link water consumption to SEQN

``` r
water_matched <- 
  pfas_data %>% 
  select(seqn) %>% 
  left_join(dietary_day1,  by = "seqn") %>% 
  left_join(dietary_day2,  by = "seqn") %>% 
  mutate(avg_320z = (dr1_320z + dr2_320z) / 2,
         avg_330z = (dr1_330z + dr2_320z) / 2,
         avgbwatz = (dr1bwatz + dr2bwatz) / 2,
         avgtws = (dr1tws + dr2tws) / 2)
```

### Water consumption table (PFAS sample)

``` r
water_table <-
  water_matched %>% 
  select(avg_320z:avgtws) %>% 
  rename(plain_water_gm = avg_320z,
         tap_water_gm = avg_330z ,
          bottled_water_gm = avgbwatz,
         tap_water_source = avgtws) %>% 
  summarise_all(funs(mean, sd, median), na.rm = TRUE) %>% 
  gather(water_consumption = plain_water_gm_mean:tap_water_source_median) 

water_table
```

    ##                        key      value
    ## 1      plain_water_gm_mean 1120.95273
    ## 2        tap_water_gm_mean  838.24921
    ## 3    bottled_water_gm_mean  546.67689
    ## 4    tap_water_source_mean    8.15009
    ## 5        plain_water_gm_sd 1027.23774
    ## 6          tap_water_gm_sd  896.85726
    ## 7      bottled_water_gm_sd  815.47016
    ## 8      tap_water_source_sd   24.12917
    ## 9    plain_water_gm_median  873.75000
    ## 10     tap_water_gm_median  570.00000
    ## 11 bottled_water_gm_median  240.00000
    ## 12 tap_water_source_median    1.00000

### Water consumption boxplot

``` r
water_matched %>% 
  select(avg_320z:avgtws) %>% 
  rename(plain_water_gm = avg_320z,
         tap_water_gm = avg_330z ,
          bottled_water_gm = avgbwatz,
         tap_water_source = avgtws) %>% 
  gather(key = "variable", value = "value", plain_water_gm:bottled_water_gm) %>% 
  group_by(variable) %>% 
  na.omit() %>% 
  ggplot(aes(x = variable, y = value)) +
    geom_boxplot() +
  labs(title = "Daily water consumption (grams) in PFAS sample", y = "grams")
```

![](summary_checkin_files/figure-markdown_github/unnamed-chunk-3-1.png)

``` r
water_matched %>%
  count(dr1tws)
```

    ## # A tibble: 6 x 2
    ##   dr1tws     n
    ##    <dbl> <int>
    ## 1      1  1279
    ## 2      2   132
    ## 3      3    16
    ## 4      4   447
    ## 5     99   147
    ## 6     NA   149
