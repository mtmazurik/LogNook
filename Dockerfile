FROM microsoft/dotnet:2.1-aspnetcore-runtime-nanoserver-1803 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk-nanoserver-1803 AS build
WORKDIR /src
COPY ["CCA.Services.Goober/CCA.Services.Goober.csproj", "CCA.Services.Goober/"]
COPY ["CCA.Services.Goober.DAL/CCA.Services.Goober.DAL.csproj", "CCA.Services.Goober.DAL/"]
RUN dotnet restore "CCA.Services.Goober/CCA.Services.Goober.csproj"
COPY . .
WORKDIR "/src/CCA.Services.Goober"
RUN dotnet build "CCA.Services.Goober.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "CCA.Services.Goober.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "CCA.services.goober.dll"]