#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

# FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS base
# WORKDIR /app
# EXPOSE 80
# EXPOSE 443

# FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
# WORKDIR /src
# COPY ["aad.csproj", ""]
# RUN dotnet restore "./dinor.csproj"
# COPY . .
# WORKDIR "/src/."
# RUN dotnet build "dinor.csproj" -c Release -o /app

# FROM build AS publish
# RUN dotnet publish "dinor.csproj" -c Release -o /app

# FROM base AS final
# WORKDIR /app
# COPY --from=publish /app .
# ENTRYPOINT ["dotnet", "dinor.dll"]

FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
WORKDIR /app
EXPOSE 5000
EXPOSE 5001
#ENV ASPNETCORE_URLS=http://+:5000
#ENV ASPNETCORE_ENVIRONMENT=Development
# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore
EXPOSE 5000 5001
# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

COPY certificate.pfx /app/out
# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2
WORKDIR /app
COPY --from=build-env /app/out .

ENTRYPOINT ["dotnet", "aad.dll"]