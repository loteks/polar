defmodule PolarWeb.Publish.Version.EventJSON do
  def create(%{event: event}) do
    %{data: %{id: event.id, name: event.name}}
  end
end
