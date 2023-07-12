# -*- coding: utf-8 -*-
"""
Created on Sat Jun 17 16:11:39 2023

@author: Eduardo HTC
"""
import numpy as np
import pandas as pd 
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
from sklearn.metrics import r2_score, mean_absolute_error

np.random.seed(10)

Peclet = 'Pe1000.csv'
#Importar arquivo de dados
data_file = pd.read_csv('C:/Users/eduar/OneDrive/Desktop/5DOF_MIX_NN_py/'+Peclet, header=0, sep=';', decimal=',', usecols=['var1','var2','var3','var4','var5','mix','DP'])

#Separar dados de entrada e resposta
x_mx = data_file[['var1','var2','var3','var4','var5']].values
x_dp = data_file[['var1','var2','var3','var4','var5']].values
y_mx = data_file['mix'].values
y_dp = data_file['DP'].values

#Separar em bases de treinamento e teste
train_ratio = 0.7
test_ratio = 1-train_ratio
num_train = int(len(x_mx)*train_ratio)
num_test = int(len(x_mx)*test_ratio)

index = np.random.permutation(len(x_mx))
                              
x_mx_train = x_mx[index[:num_train]]
x_mx_test = x_mx[index[num_train:]]
x_dp_train = x_dp[index[:num_train]]
x_dp_test = x_dp[index[num_train:]]
y_mx_train = y_mx[index[:num_train]]
y_mx_test = y_mx[index[num_train:]]
y_dp_train = y_dp[index[:num_train]]
y_dp_test = y_dp[index[num_train:]]

#Criando modelo polynomial
poly_features = PolynomialFeatures(degree=2)
x_mx_poly = poly_features.fit_transform(x_mx_train)
x_dp_poly = poly_features.fit_transform(x_dp_train)

mx_poly_model = LinearRegression()
mx_poly_model.fit(x_mx_poly, y_mx_train)

dp_poly_model = LinearRegression()
dp_poly_model.fit(x_dp_poly, y_dp_train)

#Previsoes
x_mx_poly_test = poly_features.fit_transform(x_mx_test)
x_dp_poly_test = poly_features.fit_transform(x_dp_test)
y_mx_pred = mx_poly_model.predict(x_mx_poly_test)
y_dp_pred = dp_poly_model.predict(x_dp_poly_test)

#Fit plot mix
def fitplot (real, pred, title):
    plt.figure()
    plt.plot(real,real)
    plt.scatter(real,pred)
    plt.title(title)
    plt.xlabel('CFD Value')
    plt.ylabel('Predicted Value')
    plt.show()

fitplot_mx = fitplot(y_mx_test, y_mx_pred, 'Mix Fit Plot')
fitplot_dp = fitplot(y_dp_test, y_dp_pred, 'DP Fit Plot')

fitplot_mx = pd.DataFrame(data=np.column_stack([y_mx_test, y_mx_pred]), columns=['CFD', 'Model'])
fitplot_mx.to_csv('resultados_fitplot_mx_'+Peclet, index=False)
fitplot_dp = pd.DataFrame(data=np.column_stack([y_dp_test, y_dp_pred]), columns=['CFD', 'Model'])
fitplot_dp.to_csv('resultados_fitplot_dp_'+Peclet, index=False)

#Metricas do modelo
mx_r2 = r2_score(y_mx_test, y_mx_pred)
dp_r2 = r2_score(y_dp_test, y_dp_pred)

mx_mae = mean_absolute_error(y_mx_test, y_mx_pred)
dp_mae = mean_absolute_error(y_dp_test, y_dp_pred)

print('Mix R²: {:.4f}, Mix MAE: {:.4f}, DP R²:{:.4f}, DP MAE:{:.4f}'.format(mx_r2, mx_mae, dp_r2, dp_mae))

# Exibir os coeficientes
def print_coef(model):
    coefs = model.coef_
    print("Coeficientes:")
    for i, coef in enumerate(coefs):
        print("Coeficiente {}: {:.2f}".format(i, coef))

mx_coefs = print_coef(mx_poly_model)
dp_coefs = print_coef(dp_poly_model)