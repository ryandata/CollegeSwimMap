# CollegeSwimMap
# Ryan Womack
# 2022-11-22

# set working directory
setwd("/home/ryan/github/CollegeSwimMap/data")

# expand timeout options
getOption("timeout")
options(timeout=6000)

# grab all the latest IPEDS files
download.file("https://nces.ed.gov/ipeds/datacenter/data/HD2021.zip", "HD2021.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/IC2021.zip", "IC2021.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/IC2021_AY.zip", "IC2021_AY.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/IC2021_PY.zip", "IC2021_PY.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/FLAGS2021.zip", "FLAGS2021.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/EFFY2021.zip", "EFFY2021.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/EFFY2021_DIST.zip", "EFFY2021_DIST.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/EFIA2021.zip", "EFIA2021.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/ADM2021.zip", "ADM2021.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/C2021_A.zip", "C2021_A.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/C2021_B.zip", "C2021_B.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/C2021_C.zip", "C2021_C.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/C2021DEP.zip", "C2021DEP.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/SFA2021.zip", "SFA2021.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/SFAV2021.zip", "SFAV2021.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/GR2021.zip", "GR2021.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/GR2021_L2.zip", "GR2021_L2.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/GR2021_PELL_SSL.zip", "GR2021_PELL_SSL.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/GR200_21.zip", "GR200_21.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/OM2021.zip", "OM2021.zip")


hd <- download.file("https://nces.ed.gov/ipeds/datacenter/data/HD2021.zip", "HD2021.zip")
ic <- download.file("https://nces.ed.gov/ipeds/datacenter/data/IC2021.zip", "IC2021.zip")
ic_ay <- download.file("https://nces.ed.gov/ipeds/datacenter/data/IC2021_AY.zip", "IC2021_AY.zip")
ic_py <- download.file("https://nces.ed.gov/ipeds/datacenter/data/IC2021_PY.zip", "IC2021_PY.zip")
flags <- download.file("https://nces.ed.gov/ipeds/datacenter/data/FLAGS2021.zip", "FLAGS2021.zip")
effy <- download.file("https://nces.ed.gov/ipeds/datacenter/data/EFFY2021.zip", "EFFY2021.zip")
effy_dist <- download.file("https://nces.ed.gov/ipeds/datacenter/data/EFFY2021_DIST.zip", "EFFY2021_DIST.zip")
efia <- download.file("https://nces.ed.gov/ipeds/datacenter/data/EFIA2021.zip", "EFIA2021.zip")
adm <- download.file("https://nces.ed.gov/ipeds/datacenter/data/ADM2021.zip", "ADM2021.zip")
completions_a <- download.file("https://nces.ed.gov/ipeds/datacenter/data/C2021_A.zip", "C2021_A.zip")
completions_b <- download.file("https://nces.ed.gov/ipeds/datacenter/data/C2021_B.zip", "C2021_B.zip")
completions_c <- download.file("https://nces.ed.gov/ipeds/datacenter/data/C2021_C.zip", "C2021_C.zip")
completions_dep <- download.file("https://nces.ed.gov/ipeds/datacenter/data/C2021DEP.zip", "C2021DEP.zip")
sfa <- download.file("https://nces.ed.gov/ipeds/datacenter/data/SFA2021.zip", "SFA2021.zip")
sfav <- download.file("https://nces.ed.gov/ipeds/datacenter/data/SFAV2021.zip", "SFAV2021.zip")
gr <- download.file("https://nces.ed.gov/ipeds/datacenter/data/GR2021.zip", "GR2021.zip")
gr_l2 <- download.file("https://nces.ed.gov/ipeds/datacenter/data/GR2021_L2.zip", "GR2021_L2.zip")
gr_pell <- download.file("https://nces.ed.gov/ipeds/datacenter/data/GR2021_PELL_SSL.zip", "GR2021_PELL_SSL.zip")
gr_200 <- download.file("https://nces.ed.gov/ipeds/datacenter/data/GR200_21.zip", "GR200_21.zip")
om <- download.file("https://nces.ed.gov/ipeds/datacenter/data/OM2021.zip", "OM2021.zip")

# grab the files only available for the previous year (2020)

download.file("https://nces.ed.gov/ipeds/datacenter/data/EF2020A.zip", "EF2020A.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/EF2020B.zip", "EF2020B.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/EF2020C.zip", "EF2020C.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/EF2020D.zip", "EF2020D.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/EF2020CP.zip", "EF2020CP.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/SAL2020_IS.zip", "SAL2020_IS.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/SAL2020_NIS.zip", "SAL2020_NIS.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/S2020_OC.zip", "S2020_OC.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/S2020_SIS.zip", "S2020_SIS.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/S2020_IS.zip", "S2020_IS.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/S2020_NH.zip", "S2020_NH.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/EAP2020.zip", "EAP2020.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/F1920_F1A.zip", "F1920_F1A.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/F1920_F2.zip", "F1920_F2.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/F1920_F3.zip", "F1920_F3.zip")
download.file("https://nces.ed.gov/ipeds/datacenter/data/AL2020.zip", "AL2020.zip")

efa <- download.file("https://nces.ed.gov/ipeds/datacenter/data/EF2020A.zip", "EF2020A.zip")
efb <- download.file("https://nces.ed.gov/ipeds/datacenter/data/EF2020B.zip", "EF2020B.zip")
efc <- download.file("https://nces.ed.gov/ipeds/datacenter/data/EF2020C.zip", "EF2020C.zip")
efd <- download.file("https://nces.ed.gov/ipeds/datacenter/data/EF2020D.zip", "EF2020D.zip")
ef_cp <- download.file("https://nces.ed.gov/ipeds/datacenter/data/EF2020CP.zip", "EF2020CP.zip")
sal_is <- download.file("https://nces.ed.gov/ipeds/datacenter/data/SAL2020_IS.zip", "SAL2020_IS.zip")
sal_nis <- download.file("https://nces.ed.gov/ipeds/datacenter/data/SAL2020_NIS.zip", "SAL2020_NIS.zip")
oc <- download.file("https://nces.ed.gov/ipeds/datacenter/data/S2020_OC.zip", "S2020_OC.zip")
sis <- download.file("https://nces.ed.gov/ipeds/datacenter/data/S2020_SIS.zip", "S2020_SIS.zip")
is <- download.file("https://nces.ed.gov/ipeds/datacenter/data/S2020_IS.zip", "S2020_IS.zip")
nh <- download.file("https://nces.ed.gov/ipeds/datacenter/data/S2020_NH.zip", "S2020_NH.zip")
eap <- download.file("https://nces.ed.gov/ipeds/datacenter/data/EAP2020.zip", "EAP2020.zip")
f1a <- download.file("https://nces.ed.gov/ipeds/datacenter/data/F1920_F1A.zip", "F1920_F1A.zip")
f2 <- download.file("https://nces.ed.gov/ipeds/datacenter/data/F1920_F2.zip", "F1920_F2.zip")
f3 <- download.file("https://nces.ed.gov/ipeds/datacenter/data/F1920_F3.zip", "F1920_F3.zip")
al <- download.file("https://nces.ed.gov/ipeds/datacenter/data/AL2020.zip", "AL2020.zip")

# unzip them all


# join them all
