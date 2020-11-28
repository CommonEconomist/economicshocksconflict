Replication material: *"Economic Shocks and Civil Conflict Onset in Sub-Saharan Africa, 1981-2010"*    
Submitted: 2013.07.15      
Accepted: 2013.12.19      
URL: https://www.tandfonline.com/doi/full/10.1080/10242694.2014.887489    

Data and code to replicate results as reported in the paper. 
Models fitted with Stata/IC 12.1; figures created using R.
For issues replicating the results contact me via email: vanweezel (at) pm.me.

#### Description
`code` 
* `precipitation.R`: aggregated precipitation data to country level;
* `replication_dpe.do`: replicates estimation;
* `figures_dpe.R`: creates figures as reported in the paper.

`raw_data`
* `shp`: contains shapefiles required for `precipitation.R` and `figures_dpe.R`       

`tidy_data`
* `dpe_2015`: main dataset (Stata `.dta` file);
*  `map_data.csv`: required for `figures_dpe.R`;
*  `precipitation.csv`: precipitation data aggregated to country level - the product of `precipitation.R`. 

#### BibTeX
```
@article{vanweezel2015,
  title={Economic shocks \& civil conflict onset in Sub-Saharan Africa, 1981--2010},
  author={Van Weezel, Stijn},
  journal={Defence and Peace Economics},
  volume={26},
  number={2},
  pages={153--177},
  year={2015},
  publisher={Taylor \& Francis}
}
```