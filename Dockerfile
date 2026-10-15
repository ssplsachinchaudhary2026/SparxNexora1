FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY SparxNexoraExpanded.zip ./
RUN apt-get update     && apt-get install -y --no-install-recommends unzip     && rm -rf /var/lib/apt/lists/*
RUN unzip -q SparxNexoraExpanded.zip -d /src/app

WORKDIR /src/app/SparxNexoraExpanded
RUN dotnet restore "SparxNexora.csproj"
RUN dotnet publish "SparxNexora.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish ./

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
ENTRYPOINT ["dotnet", "SparxNexora.dll"]
