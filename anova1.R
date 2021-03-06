# Create data frame
alloy=data.frame(strength=c(250,264,256,260,239,263,254,267,265,267,257,279,269,273,277,253,258,262,264,273),
                 treat=factor(rep(c("A","B","C","D"),each=5)))
print(alloy)

means=tapply(alloy$strength,alloy$treat,mean) # obtain means by trt
means
tapply(alloy$strength,alloy$treat,sd) # obtain st.dev. by trt
#best to summarisue data using ddply function in plyr package

windows(6.5,5.5)
# Dot plot 
stripchart(strength~treat, data=alloy, method="stack", vertical=TRUE,
           pch=1, cex=1.5, xlab="Factor", ylab="strength", main="Dotplots by Treatments")
title(sub="pre-analysis plot", adj=0, cex=5/6)
mtext("Example")
points(c(1,2,3,4),tapply(alloy$strength,alloy$treat,mean),col=2,pch=8)
abline(h=mean(alloy$strength),col=3)
legend(3,250, c("Observations", " Trt Mean","Grand Mean"), col = c(1,2,3), text.col= "black",
       lty=c(0,0,1),pch=c(1,8,NA),bg='gray90')

### Conduct the One-Way ANOVA comparing change in strength by treatment
attach(alloy)

m1=aov(strength~treat,data=alloy)
summary(m1)
summary.lm(m1) #fit as a regression

########### DIFFERENCES IN MEANS
# Bonferroni method for CRD and RBD models (all pairwise comparisons)
source("http://users.stat.ufl.edu/~athienit/Bonf.R")
Bonf(strength~treat,data=alloy)

#### Obtain Tukey's Comparisons among levels of treatment
alloy.Tukey=TukeyHSD(m1, "treat")
print(alloy.Tukey)
windows(width=5,height=5,pointsize=10)
plot(alloy.Tukey, sub="Alloy Data", adj=0)
mtext("Tukey Honest Significant Differences",side=3,line=0.5)

#### Fisher LSD (difference)
qt(0.975,16)*sqrt(MSE*(1/5+1/5))

# Do assumptions hold?
source("http://users.stat.ufl.edu/~athienit/check.R")
check(m1)