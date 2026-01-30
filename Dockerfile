# Multi-stage Dockerfile for AspnetCoreMvcFull (dotnet 8)
# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy project file and restore dependencies (layer caching)
COPY ["AspnetCoreMvcFull.csproj", "./"]
RUN dotnet restore "AspnetCoreMvcFull.csproj"

# Copy remaining sources and publish
COPY . .
RUN dotnet publish "AspnetCoreMvcFull.csproj" -c Release -o /app/publish --no-restore

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Listen on port 80
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

# Copy published app from build stage
COPY --from=build /app/publish .

# Final entrypoint
ENTRYPOINT ["dotnet", "AspnetCoreMvcFull.dll"]
