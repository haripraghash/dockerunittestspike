FROM microsoft/dotnet:2.2-aspnetcore-runtime-alpine AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY dokerunittestspike/dokerunittestspike.csproj dokerunittestspike/
COPY dockerunittestspike.services/dockerunittestspike.services.csproj dockerunittestspike.services/
COPY dockerunittestspike.domain/dockerunittestspike.domain.csproj dockerunittestspike.domain/
COPY dockerunittestspike.dataaccess/dockerunittestspike.dataaccess.csproj dockerunittestspike.dataaccess/
COPY dockerunittestspike.dto/dockerunittestspike.dto.csproj dockerunittestspike.dto/
RUN dotnet restore dokerunittestspike/dokerunittestspike.csproj
COPY . .
WORKDIR /src/dokerunittestspike
RUN dotnet build dokerunittestspike.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish dokerunittestspike.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "dokerunittestspike.dll"]
