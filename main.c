#include "raylib.h"

#define RAYGUI_IMPLEMENTATION
#define MAX_CURL_HELP_SIZE 1000
#include "raygui.h"

int main()
{
    //
    InitWindow(1200, 1200, "Curly");
    SetTargetFPS(60);

    FILE *fp;
    int status;
    char path[MAX_CURL_HELP_SIZE];
    fp = popen("curl --help all", "r");
    if(fp == NULL){
        printf("oh shit");
        return 1;
    }
    while(fgets(path,MAX_CURL_HELP_SIZE,fp)!=NULL){
        printf("%s",path);
    }

    bool showMessageBox = false;

    while (!WindowShouldClose())
    {
        // Draw
        //----------------------------------------------------------------------------------
        BeginDrawing();
            ClearBackground(GetColor(GuiGetStyle(DEFAULT, BACKGROUND_COLOR)));

            if (GuiButton((Rectangle){ 24, 24, 120, 30 }, "#191#Show Message")) showMessageBox = true;

            if (showMessageBox)
            {
                int result = GuiMessageBox((Rectangle){ 85, 70, 250, 100 },
                    "#191#Message Box", "Hi! This is a message!", "Nice;Cool");

                if (result >= 0) showMessageBox = false;
            }

        EndDrawing();
    }

    CloseWindow();
    return 0;
}