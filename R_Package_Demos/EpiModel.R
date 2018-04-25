# EpiModel Demo
# Script from Owen Page
# April 25th, 2018
# KER

library(EpiModel)

#SI mod
param <- param.dcm (inf.prob=0.3, act.rate=0.5)
init <- init.dcm(s.num=1000, i.num=1)
control <- control.dcm(type="SI", nsteps=200)

mod <- dcm(param, init, control)
mod

plot(mod) # basic plot
comp_plot(mod, at=50, digits=1) # flow diagram

#SIR mod
param <- param.dcm (inf.prob=0.5, act.rate=0.3, rec.rate= 1/40)
init <- init.dcm(s.num=1000, i.num=1, r.num=0)
control <- control.dcm(type="SIR", nsteps=500, dt=.5) 

mod <- dcm(param, init, control)
mod

plot(mod) # basic plot
comp_plot(mod, at=70, digits=1)

# plot for disease incidence
plot(mod, y="si.flow")
plot(mod, y="si.flow", col="goldenrod", legend= "n")


#SIS 
param <- param.dcm (inf.prob=0.2, act.rate=0.5, rec.rate=0.02)
init <- init.dcm(s.num=1000, i.num=1)
control <- control.dcm(type="SIS", nsteps=200)

mod <- dcm(param, init, control)
mod

plot(mod) # basic plot
comp_plot(mod, at=59, digits=1)

# w/ Demography
#SIR
param <- param.dcm(inf.prob = 0.33, act.rate = 1.5, rec.rate = 1/10,
                   b.rate = 1/95, ds.rate = 1/100, di.rate = 1/60, dr.rate = 1/100)
init <- init.dcm(s.num = 1000, i.num = 1, r.num = 0) 
control <- control.dcm(type = "SIR", nsteps = 500, dt = 0.5) 
mod <- dcm(param, init, control)

plot(mod) # basic plot
comp_plot(mod, at=70, digits=1)

#plotting comparment size
plot(mod, y="si.flow", col="goldenrod")

# SI
param <- param.dcm (inf.prob=0.3, act.rate=0.5,
                    b.rate=1/95, ds.rate=1/100, di.rate=1/60)
init <- init.dcm(s.num=1000, i.num=1)
control <- control.dcm(type="SI", nsteps=200)

mod <- dcm(param, init, control)
mod
plot(mod)
comp_plot(mod, at=50)

#Sensitivity Analyses
param <- param.dcm (inf.prob=0.2, act.rate=seq(0.25,0.5,0.05), rec.rate=0.02)
init <- init.dcm(s.num=1000, i.num=1)
control <- control.dcm(type="SIS", nsteps=200)

mod <- dcm(param, init, control)
mod

plot(mod) # basic plot
plot(mod, run=2, legend="n")
comp_plot(mod, at=59)

#plotting with color palette
plot(mod, col=1:6)
plot(mod, y="si.flow", col="Blues")
plot(mod, col=rainbow(3), lty=rep(1:2, each=3))

#variation in more than one parameter:
act.rates <- c(0.2, 0.2, 0.4, 0.4, 0.6, 0.6)
inf.probs <- c(0.1,0.2,0.1,0.2,0.1,0.2)
param <- param.dcm (inf.prob=inf.probs, act.rate=act.rates, rec.rate=0.02)
init <- init.dcm(s.num=1000, i.num=1)
control <- control.dcm(type="SIS", nsteps=200)

mod <- dcm(param, init, control)
mod
plot(mod)

#to extract the data of a specific run
z <- head(as.data.frame(mod, run=4))
z


# Bipartite or two group models
param <- param.dcm(inf.prob=0.4, inf.prob.g2 = 0.1, act.rate=0.25, balance= "g1",
                   b.rate=1/100, b.rate.g2 = NA, ds.rate=1/100, ds.rate.g2=1/100,
                   di.rate =1/50, di.rate.g2=1/50)

# here we establish the birth and death rates for the group groups. Incorporating a balance to g1 enables us to derive the act.rate for group 2 over time
init <- init.dcm(s.num = 500, i.num = 1, s.num.g2 = 500, i.num.g2 = 0) #same principal here
control <- control.dcm(type = "SI", nsteps = 500)
mod <- dcm(param, init, control)
mod
plot(mod)


#ICMs
param <- param.icm(inf.prob = 0.2, act.rate = 0.25)# note the function is now param.icm
init <- init.icm(s.num = 500, i.num = 1)
control <- control.icm(type = "SI", nsims = 10, nsteps = 300)
mod <- icm(param, init, control)
mod

summary(mod, at = 125) # to request summary of individual timestep 
head(as.data.frame(mod, out= "mean"))
tail(as.data.frame(mod, out = "vals", sim = 1))

plot(mod) # standard plot
plot(mod, sim.lines = TRUE, mean.smooth = FALSE, qnts.smooth = FALSE)


#comparing dcm and icm
#dcm
param <- param.dcm(inf.prob = 0.3, act.rate = 0.92, rec.rate = 1/50,
                   b.rate = 1/50, ds.rate = 1/60, di.rate = 1/40, dr.rate = 1/60)
init <- init.dcm(s.num = 800, i.num = 200, r.num = 0)
control <- control.dcm(type = "SIR", nsteps = 300)
mD <- dcm(param, init, control)

# icm
param <- param.icm(inf.prob = 0.3, act.rate = 0.92, rec.rate = 1/50,
                   b.rate = 1/50, ds.rate = 1/60, di.rate = 1/40,
                   dr.rate = 1/60)
init <- init.icm(s.num = 800, i.num = 200, r.num = 0)
control <- control.icm(type = "SIR", nsteps = 300, nsims = 10)
mI <- icm(param, init, control)

#to get rid of stocastic birth and death rates
control <- control.icm(type = "SIR", nsteps = 300, nsims = 10,
                       b.rand = FALSE, d.rand = FALSE) #this should cause less variability
mI_2 <- icm(param, init, control)

# plotting using ```add```
plot(mD, alpha = 0.75, lwd = 4, main = "DCM and ICM Comparison")
plot(mI, qnts = FALSE, sim.lines = FALSE, add = TRUE, mean.lty = 2, legend = FALSE)
plot(mI_2, qnts = FALSE, sim.lines = FALSE, add = TRUE, mean.lty = 3, legend = FALSE)

#SIS bipartite with demography
param <- param.icm(inf.prob = 0.3, inf.prob.g2 = 0.1, act.rate = 0.5, balance = "g1",
                   rec.rate = 1/25, rec.rate.g2 = 1/50, b.rate = 1/100, b.rate.g2 = NA,
                   ds.rate = 1/100, ds.rate.g2 = 1/100, di.rate = 1/90, di.rate.g2 = 1/90)
init <- init.icm(s.num = 500, i.num = 1, s.num.g2 = 500, i.num.g2 = 1)
control <- control.icm(type = "SIS", nsteps = 500, nsims = 10)

mod <- icm(param, init, control)
plot(mod)


print(mod_SIR_1g_op)


# Part II
SEIR <- function(t, t0, parms) {
  with(as.list(c(t0, parms)), {
    
    # Population size
    num <- s.num + e.num + i.num + r.num
    
    # Effective contact rate and FOI from a rearrangement of Beta * c * D
    ce <- R0 / i.dur 
    lambda <- ce * i.num/num
    
    dS <- -lambda*s.num
    dE <- lambda*s.num - (1/e.dur)*e.num
    dI <- (1/e.dur)*e.num - (1 - cfr)*(1/i.dur)*i.num - cfr*(1/i.dur)*i.num
    dR <- (1 - cfr)*(1/i.dur)*i.num
    
    # Compartments and flows  part of the derivative vector
    # Other calculations to be output are outside the vector, but within the containing list
    list(c(dS, dE, dI, dR, 
           se.flow = lambda * s.num,
           ei.flow = (1/e.dur) * e.num,
           ir.flow = (1 - cfr)*(1/i.dur) * i.num,
           d.flow = cfr*(1/i.dur)*i.num),
         num = num,
         i.prev = i.num / num,
         ei.prev = (e.num + i.num)/num)
  })
}
#running SEIR
param <- param.dcm(R0 = 2.9, e.dur = 12, i.dur = 14, cfr =  0.95)
init <- init.dcm(s.num = 1e6, e.num = 50, i.num = 12, r.num = 0,
                 se.flow = 0, ei.flow = 0, ir.flow = 0, d.flow = 0)
control <- control.dcm(nsteps = 500, dt = 1, new.mod = SEIR)
mod <- dcm(param, init, control)
mod

#plotting
par(mfrow = c(1, 2))
plot(mod, y = "i.num", main = "Prevalence")
plot(mod, y = "se.flow",  main = "Incidence")

