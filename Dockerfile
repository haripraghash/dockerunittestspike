FROM microsoft/dotnet:2.2-aspnetcore-runtime-alpine AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.2-sdk-alpine AS build
WORKDIR /src
COPY ["dokerunittestspike.sln", "dokerunittestspike.sln"]
COPY ["dockerunittestspike.dto/dockerunittestspike.dto.csproj", "dockerunittestspike.dto/"]
COPY ["dockerunittestspike.domain/dockerunittestspike.domain.csproj", "dockerunittestspike.domain/"]
COPY ["dockerunittestspike.dataaccess/dockerunittestspike.dataaccess.csproj", "dockerunittestspike.dataaccess/"]
COPY ["dockerunittestspike.services/dockerunittestspike.services.csproj", "dockerunittestspike.services/"]
COPY ["dokerunittestspike/dokerunittestspike.csproj", "dokerunittestspike/"]
RUN dotnet restore 

COPY . ./
#RUN dotnet test dockerunittestspike.unit.tests --logger trx -o /out/testresults -c Release

WORKDIR "/src/dokerunittestspike"
RUN dotnet build "dokerunittestspike.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "dokerunittestspike.csproj" -c Release -o /app --no-build

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "dokerunittestspike.dll"]