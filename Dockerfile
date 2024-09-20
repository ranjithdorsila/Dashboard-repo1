# Use the official .NET SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application code
COPY . ./

# Build the application
RUN dotnet publish -c Release -o out

# Use the official .NET Runtime image for running
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

WORKDIR /app
COPY --from=build /app/out ./

# Expose the application port (replace 80 with your port)
EXPOSE 80

# Start the application
ENTRYPOINT ["dotnet", "YourAppName.dll"]
