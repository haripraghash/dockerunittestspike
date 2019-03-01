FROM microsoft/dotnet:2.2-sdk-alpine AS build
WORKDIR /src
COPY ["/dockerunittestspike.dataaccess/dockerunittestspike.dataaccess.csproj", "dockerunittestspike.dataaccess/"]
COPY ["/dockerunittestspike.domain/dockerunittestspike.domain.csproj", "dockerunittestspike.domain/"]
COPY ["/dockerunittestspike.dto/dockerunittestspike.dto.csproj", "dockerunittestspike.dto/"]
COPY ["/dockerunittestspike.services/dockerunittestspike.services.csproj", "dockerunittestspike.services/"]
COPY ["/dockerunittestspike.unit.tests/dockerunittestspike.unit.tests.csproj", "dockerunittestspike.unit.tests/"]

RUN dotnet restore "dockerunittestspike.unit.tests/dockerunittestspike.unit.tests.csproj"
COPY . ./
WORKDIR /src/dockerunittestspike.unit.tests/
