FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["CCA.Services.LogNook/CCA.Services.LogNook.csproj", "CCA.Services.LogNook/"]
RUN dotnet restore "CCA.Services.LogNook/CCA.Services.LogNook.csproj"
COPY . .
WORKDIR "/src/CCA.Services.LogNook"
RUN dotnet build "CCA.Services.LogNook.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "CCA.Services.LogNook.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "cca.services.lognook.dll"]