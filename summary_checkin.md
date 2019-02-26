summary\_checkin
================
Team LSD: Adnan, Jenni, Stephen
February 13, 2019

-   [Per- and polyfluoroalkyl substances (PFAS) and Body Mass](#per--and-polyfluoroalkyl-substances-pfas-and-body-mass)
    -   [26 February 2019 Check-In](#february-2019-check-in)
        -   [1. Water and food consumption and consumer product use influence PFAS serum concentrations.](#water-and-food-consumption-and-consumer-product-use-influence-pfas-serum-concentrations.)
        -   [2. Elevated PFAS concentrations contribute to higher BMI.](#elevated-pfas-concentrations-contribute-to-higher-bmi.)
        -   [3. Serum PFAS levels serve as a mediator between water/food consumption and body mass.](#serum-pfas-levels-serve-as-a-mediator-between-waterfood-consumption-and-body-mass.)
    -   [NHANES Dietary Interviews](#nhanes-dietary-interviews)
    -   [PFAS](#pfas)
        -   [Load and Inspect PFAS data](#load-and-inspect-pfas-data)
        -   [2015-2016 PFAS summary table](#pfas-summary-table)
    -   [Body Mass](#body-mass)
        -   [Load and Inspect BMI data](#load-and-inspect-bmi-data)
        -   [Inspect body mass data from 2015-2016](#inspect-body-mass-data-from-2015-2016)
        -   [Load water consumption](#load-water-consumption)

Per- and polyfluoroalkyl substances (PFAS) and Body Mass
========================================================

26 February 2019 Check-In
-------------------------

### 1. Water and food consumption and consumer product use influence PFAS serum concentrations.

**IV**: Survey Questions: drinking water sources, drinking water consumption, canned goods, microwave popcorn, beauty and personal care products (including dental floss)

**DV**: Serum PFAS concentrations (Outcome): PFDeA, PFHxS, Me-PFOSA-AcOH, PFNA, PFUA, PFDoA, n-PFOA, Sb-PFOA, n-PFOS, Sm-PFOS

### 2. Elevated PFAS concentrations contribute to higher BMI.

**IV**: Serum PFAS concentrations (Outcome): PFDeA, PFHxS, Me-PFOSA-AcOH, PFNA, PFUA, PFDoA, n-PFOA, Sb-PFOA, n-PFOS, Sm-PFOS

**DV**: Body weight, BMI

Potential confounders, effect modifiers, or co-variates of interest: \* age \* gestational diabetes \* pre-diabetes / diabetes \* sex \* smoking status \* household income \* alcohol \* waist circumference, 2 years of age and older \* sagittal abdominal diameter, 8 years of age and older

*References*: <https://www.ncbi.nlm.nih.gov/pubmed/?term=PFAS+and+BMI>

### 3. Serum PFAS levels serve as a mediator between water/food consumption and body mass.

**DAG**:

water/food/product use (exposure) --&gt; PFAS serum concentrations (internal dose) --&gt; increased body mass (biological effect)

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

### Load water consumption

``` r
dietary_day1 <- nhanes_load_data("DR1TOT_I", "2015-2016") %>% 
    select(SEQN, DR1_320Z, DR1_330Z, DR1BWATZ, DR1TWS) %>% 
  janitor::clean_names() 
```

    ## Downloading DR1TOT_I.XPT to C:\Users\slewa\AppData\Local\Temp\RtmpoHytlb/DR1TOT_I.XPT

``` r
dietary_day2 <- nhanes_load_data("DR2TOT_I", "2015-2016") %>% 
    select(SEQN, DR2_320Z, DR2_330Z, DR2BWATZ, DR2TWS) %>% 
  janitor::clean_names()
```

    ## Downloading DR2TOT_I.XPT to C:\Users\slewa\AppData\Local\Temp\RtmpoHytlb/DR2TOT_I.XPT

#### Link water consumption to SEQN

``` r
water_matched <- 
  pfas_data %>% 
  select(seqn) %>% 
  left_join(dietary_day1,  by = "seqn") %>% 
  left_join(dietary_day2,  by = "seqn")
```
