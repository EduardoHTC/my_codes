# -*- coding: utf-8 -*-
"""
Created on Sat Jun 17 18:15:52 2023

@author: Eduardo HTC
"""
#============== Algoritmo multi-objetivo ============== 

#Importar bibliotecas do algoritmo NSGA2
from pymoo.algorithms.moo.nsga2 import NSGA2
from pymoo.factory import get_termination
from pymoo.optimize import minimize
from pymoo.core.problem import Problem
from pymoo.visualization.scatter import Scatter
from poly_reg_model import *


#Definindo os limites das variaveis
lower_limits = np.array([min(x_mx[:,0]),min(x_mx[:,1]),min(x_mx[:,2]),min(x_mx[:,3]),min(x_mx[:,4])])
upper_limits = np.array([max(x_mx[:,0]),max(x_mx[:,1]),max(x_mx[:,2]),max(x_mx[:,3]),max(x_mx[:,4])])

#Definicao da funcao objetiva
def obj_function(x):
  x_pred = poly_features.fit_transform(x)
  f1 = -mx_poly_model.predict(x_pred)
  f2 = dp_poly_model.predict(x_pred)
  return [f1,f2]

#Definindo o problema de otimiza��o
class problema(Problem):
  def __init__(self):
    super().__init__(n_var=5,n_obj=2,n_constr=0,xl=lower_limits,xu=upper_limits)
  def _evaluate(self,x,out,*args,**kwargs):
    out['F'] = obj_function(x)

#Configurando o algoritmo NSGA2
nsga = NSGA2(pop_size = 150, prob_mut = 0.2, prob_cross = 0.8)
opt_problem = problema()
criteria = ('n_gen', 250)
nsga_solver = minimize(opt_problem, algorithm = nsga,termination = criteria, seed = 1,verbose=True)

#Curva de pareto
curva_pareto = nsga_solver.F
curva_pareto_mx = -1.0*curva_pareto[:,0]
curva_pareto_mx = curva_pareto_mx.reshape(-1,1)
curva_pareto_dp = curva_pareto[:,1]
curva_pareto_dp = curva_pareto_dp.reshape(-1,1)

plt.figure()
plt.scatter(curva_pareto_mx, curva_pareto_dp)
plt.xlabel('mix')
plt.ylabel('DP')
plt.title('Pareto Solutions')
plt.show()

#Salvar os resultados em arquivo csv
curva_pareto_x = nsga_solver.X
curva_pareto_y = nsga_solver.F

curva_pareto_y = np.column_stack((curva_pareto_mx,curva_pareto_dp))

resultados = pd.DataFrame(data=np.column_stack([curva_pareto_x, curva_pareto_y]), columns=['var1', 'var2', 'var3', 'var4', 'var5', 'mix', 'DP'])
resultados.to_csv('resultados_pareto'+Peclet, index=False)