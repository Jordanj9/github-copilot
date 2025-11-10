#!/bin/bash

# Verifica si se ha proporcionado un nombre de proyecto
if [ -z "$1" ]
then
    echo "Por favor, proporciona un nombre para el proyecto."
    exit 1
fi

PROJECT_NAME=$1

# Verifica si .NET SDK está instalado
if ! command -v dotnet &> /dev/null
then
    echo ".NET SDK no está instalado. Por favor, instálalo para continuar."
    exit 1
fi

# crea proyecto de minimal api de .net
echo "CREANDO PROYECTO DE MINIMAL API DE .NET"
dotnet new webapi -n $PROJECT_NAME

# Crea proyecto de pruebas para el proyecto de minimal api de .net
echo "CREANDO PROYECTO DE TESTS PARA MINIMAL API DE .NET"
dotnet new xunit -n ${PROJECT_NAME}.Tests

# Asocia los dos proeyectos
echo "ASOCIANDO PROYECTOS"
dotnet add ${PROJECT_NAME}.Tests/${PROJECT_NAME}.Tests.csproj reference ${PROJECT_NAME}/${PROJECT_NAME}.csproj

# Crea un archivo de solución
echo "CREANDO SOLUCIÓN"
dotnet new sln -n $PROJECT_NAME

# Agrega ambos proyectos a la solución
echo "AGREGANDO PROYECTOS A LA SOLUCIÓN"
dotnet sln MinimalApi.sln add ${PROJECT_NAME}/${PROJECT_NAME}.csproj
dotnet sln MinimalApi.sln add ${PROJECT_NAME}.Tests/${PROJECT_NAME}.Tests.csproj

# Agrega los paquetes necesarios para el proyecto de tests de minimal api de .net
echo "AGREGANDO PAQUETES NECESARIOS AL PROYECTO DE TESTS"
dotnet add ${PROJECT_NAME}/${PROJECT_NAME}.Tests.csproj package Microsoft.AspNetCore.Mvc.Testing
dotnet add ${PROJECT_NAME}/${PROJECT_NAME}.Tests.csproj package MiniValidation

# Agrega un archivo de Docker en el proyecto de minimal api de .net
echo "AGREGANDO DOCKERFILE AL PROYECTO DE MINIMAL API"

cd $PROJECT_NAME

cat <<EOL > Dockerfile
# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy the project files and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application code
COPY . ./
RUN dotnet publish -c Release -o out

# Use the official ASP.NET Core runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out .

# Expose port 80
EXPOSE 80

# Run the application
ENTRYPOINT ["dotnet", "${PROJECT_NAME}.dll"]
EOL

echo "ARCHIVO DOCKERFILE AGREGADO EXITOSAMENTE"

cd ..

echo "PROYECTO DE MINIMAL API DE .NET CREADO EXITOSAMENTE"