.class public Lcom/tweakaio/TweakAIOActivity;
.super Landroid/app/Activity;
.source "TweakAIOActivity.java"


# static fields
.field private static final FILE_NAME:Ljava/lang/String; = "/data/tweakaio/tweakaio.conf"


# instance fields
.field private linearLayout:Landroid/widget/LinearLayout;

.field private saveButton:Landroid/widget/Button;

.field textData:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List",
            "<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private valueNameVsComponent:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map",
            "<",
            "Ljava/lang/String;",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 1

    .prologue
    .line 11
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    .line 18
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcom/tweakaio/TweakAIOActivity;->valueNameVsComponent:Ljava/util/Map;

    return-void
.end method

.method static synthetic access$000(Lcom/tweakaio/TweakAIOActivity;)V
    .locals 0
    .parameter "x0"

    .prologue
    .line 11
    invoke-direct {p0}, Lcom/tweakaio/TweakAIOActivity;->updateFile()V

    return-void
.end method

.method private addCheckBoxToLayout([Ljava/lang/String;)V
    .locals 4
    .parameter "values"

    .prologue
    const/4 v3, 0x0

    .line 101
    new-instance v0, Landroid/widget/CheckBox;

    invoke-direct {v0, p0}, Landroid/widget/CheckBox;-><init>(Landroid/content/Context;)V

    .line 102
    .local v0, checkBox:Landroid/widget/CheckBox;
    aget-object v1, p1, v3

    invoke-virtual {v0, v1}, Landroid/widget/CheckBox;->setText(Ljava/lang/CharSequence;)V

    .line 103
    const/4 v1, 0x1

    aget-object v1, p1, v1

    const-string v2, "on"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/CheckBox;->setChecked(Z)V

    .line 104
    iget-object v1, p0, Lcom/tweakaio/TweakAIOActivity;->linearLayout:Landroid/widget/LinearLayout;

    invoke-virtual {v1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 105
    iget-object v1, p0, Lcom/tweakaio/TweakAIOActivity;->valueNameVsComponent:Ljava/util/Map;

    aget-object v2, p1, v3

    invoke-interface {v1, v2, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 106
    return-void
.end method

.method private addCommentInTextView(Ljava/lang/String;)V
    .locals 2
    .parameter "text"

    .prologue
    .line 75
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 76
    .local v0, textView:Landroid/widget/TextView;
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 77
    iget-object v1, p0, Lcom/tweakaio/TweakAIOActivity;->linearLayout:Landroid/widget/LinearLayout;

    invoke-virtual {v1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 78
    return-void
.end method

.method private addEditableWidget(Ljava/lang/String;)V
    .locals 5
    .parameter "text"

    .prologue
    const/4 v4, 0x1

    .line 81
    const-string v1, "="

    invoke-virtual {p1, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    .line 82
    .local v0, values:[Ljava/lang/String;
    aget-object v1, v0, v4

    const-string v2, "\""

    const-string v3, ""

    invoke-virtual {v1, v2, v3}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v1

    aput-object v1, v0, v4

    .line 83
    aget-object v1, v0, v4

    const-string v2, "on"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    aget-object v1, v0, v4

    const-string v2, "off"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 84
    :cond_0
    invoke-direct {p0, v0}, Lcom/tweakaio/TweakAIOActivity;->addCheckBoxToLayout([Ljava/lang/String;)V

    .line 88
    :goto_0
    return-void

    .line 86
    :cond_1
    invoke-direct {p0, v0}, Lcom/tweakaio/TweakAIOActivity;->addTextBoxWithLabel([Ljava/lang/String;)V

    goto :goto_0
.end method

.method private addTextBoxWithLabel([Ljava/lang/String;)V
    .locals 4
    .parameter "values"

    .prologue
    const/4 v3, 0x0

    .line 91
    new-instance v1, Landroid/widget/TextView;

    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 92
    .local v1, textView:Landroid/widget/TextView;
    aget-object v2, p1, v3

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 93
    new-instance v0, Landroid/widget/EditText;

    invoke-direct {v0, p0}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    .line 94
    .local v0, editText:Landroid/widget/EditText;
    const/4 v2, 0x1

    aget-object v2, p1, v2

    invoke-virtual {v0, v2}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 95
    iget-object v2, p0, Lcom/tweakaio/TweakAIOActivity;->linearLayout:Landroid/widget/LinearLayout;

    invoke-virtual {v2, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 96
    iget-object v2, p0, Lcom/tweakaio/TweakAIOActivity;->linearLayout:Landroid/widget/LinearLayout;

    invoke-virtual {v2, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 97
    iget-object v2, p0, Lcom/tweakaio/TweakAIOActivity;->valueNameVsComponent:Ljava/util/Map;

    aget-object v3, p1, v3

    invoke-interface {v2, v3, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 98
    return-void
.end method

.method private getValueFromWidget(Ljava/lang/String;)Ljava/lang/String;
    .locals 7
    .parameter "text"
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .prologue
    const/4 v6, 0x0

    .line 139
    const-string v4, "="

    invoke-virtual {p1, v4}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v2

    .line 140
    .local v2, values:[Ljava/lang/String;
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    aget-object v5, v2, v6

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "=\""

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 142
    .local v1, valueToWrite:Ljava/lang/String;
    iget-object v4, p0, Lcom/tweakaio/TweakAIOActivity;->valueNameVsComponent:Ljava/util/Map;

    aget-object v5, v2, v6

    invoke-interface {v4, v5}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/view/View;

    .line 143
    .local v3, view:Landroid/view/View;
    instance-of v4, v3, Landroid/widget/EditText;

    if-eqz v4, :cond_1

    .line 144
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    check-cast v3, Landroid/widget/EditText;

    .end local v3           #view:Landroid/view/View;
    invoke-virtual {v3}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 149
    :cond_0
    :goto_0
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "\""

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    return-object v4

    .line 145
    .restart local v3       #view:Landroid/view/View;
    :cond_1
    instance-of v4, v3, Landroid/widget/CheckBox;

    if-eqz v4, :cond_0

    .line 146
    check-cast v3, Landroid/widget/CheckBox;

    .end local v3           #view:Landroid/view/View;
    invoke-virtual {v3}, Landroid/widget/CheckBox;->isChecked()Z

    move-result v0

    .line 147
    .local v0, checked:Z
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    if-eqz v0, :cond_2

    const-string v5, "on"

    :goto_1
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    goto :goto_0

    :cond_2
    const-string v5, "off"

    goto :goto_1
.end method

.method private readToEndOfFile(Ljava/io/BufferedReader;)V
    .locals 2
    .parameter "bufferedReader"
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .prologue
    .line 67
    invoke-virtual {p1}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v0

    .line 69
    .local v0, s:Ljava/lang/String;
    :cond_0
    iget-object v1, p0, Lcom/tweakaio/TweakAIOActivity;->textData:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 70
    invoke-virtual {p1}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v0

    .line 71
    if-nez v0, :cond_0

    .line 72
    return-void
.end method

.method private readTweakAIOFile()V
    .locals 6

    .prologue
    .line 53
    :try_start_0
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;

    move-result-object v2

    .line 54
    .local v2, r:Ljava/lang/Runtime;
    const-string v4, "su"

    invoke-virtual {v2, v4}, Ljava/lang/Runtime;->exec(Ljava/lang/String;)Ljava/lang/Process;

    move-result-object v3

    .line 55
    .local v3, suProcess:Ljava/lang/Process;
    new-instance v0, Ljava/io/BufferedReader;

    new-instance v4, Ljava/io/FileReader;

    const-string v5, "/data/tweakaio/tweakaio.conf"

    invoke-direct {v4, v5}, Ljava/io/FileReader;-><init>(Ljava/lang/String;)V

    invoke-direct {v0, v4}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 57
    .local v0, bufferedReader:Ljava/io/BufferedReader;
    :try_start_1
    invoke-direct {p0, v0}, Lcom/tweakaio/TweakAIOActivity;->readToEndOfFile(Ljava/io/BufferedReader;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 59
    :try_start_2
    invoke-virtual {v0}, Ljava/io/BufferedReader;->close()V

    .line 64
    return-void

    .line 59
    :catchall_0
    move-exception v4

    invoke-virtual {v0}, Ljava/io/BufferedReader;->close()V

    throw v4
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    .line 61
    .end local v0           #bufferedReader:Ljava/io/BufferedReader;
    .end local v2           #r:Ljava/lang/Runtime;
    .end local v3           #suProcess:Ljava/lang/Process;
    :catch_0
    move-exception v4

    move-object v1, v4

    .line 62
    .local v1, e:Ljava/lang/Exception;
    new-instance v4, Ljava/lang/IllegalStateException;

    invoke-direct {v4, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/Throwable;)V

    throw v4
.end method

.method private showFile()V
    .locals 3

    .prologue
    .line 40
    invoke-direct {p0}, Lcom/tweakaio/TweakAIOActivity;->readTweakAIOFile()V

    .line 41
    iget-object v2, p0, Lcom/tweakaio/TweakAIOActivity;->textData:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    .local v0, i$:Ljava/util/Iterator;
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    .line 42
    .local v1, text:Ljava/lang/String;
    const-string v2, ""

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_0

    const-string v2, "#"

    invoke-virtual {v1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 43
    :cond_0
    invoke-direct {p0, v1}, Lcom/tweakaio/TweakAIOActivity;->addCommentInTextView(Ljava/lang/String;)V

    goto :goto_0

    .line 45
    :cond_1
    invoke-direct {p0, v1}, Lcom/tweakaio/TweakAIOActivity;->addEditableWidget(Ljava/lang/String;)V

    goto :goto_0

    .line 49
    .end local v1           #text:Ljava/lang/String;
    :cond_2
    return-void
.end method

.method private updateFile()V
    .locals 4

    .prologue
    .line 111
    :try_start_0
    new-instance v0, Ljava/io/BufferedWriter;

    new-instance v2, Ljava/io/FileWriter;

    const-string v3, "/data/tweakaio/tweakaio.conf"

    invoke-direct {v2, v3}, Ljava/io/FileWriter;-><init>(Ljava/lang/String;)V

    invoke-direct {v0, v2}, Ljava/io/BufferedWriter;-><init>(Ljava/io/Writer;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 113
    .local v0, bufferedWriter:Ljava/io/BufferedWriter;
    :try_start_1
    invoke-direct {p0, v0}, Lcom/tweakaio/TweakAIOActivity;->writeAllDataToFile(Ljava/io/BufferedWriter;)V

    .line 114
    invoke-virtual {v0}, Ljava/io/BufferedWriter;->flush()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 116
    :try_start_2
    invoke-virtual {v0}, Ljava/io/BufferedWriter;->close()V
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_0

    .line 122
    invoke-virtual {p0}, Lcom/tweakaio/TweakAIOActivity;->finish()V

    .line 123
    return-void

    .line 116
    :catchall_0
    move-exception v2

    :try_start_3
    invoke-virtual {v0}, Ljava/io/BufferedWriter;->close()V

    throw v2
    :try_end_3
    .catch Ljava/io/IOException; {:try_start_3 .. :try_end_3} :catch_0

    .line 118
    .end local v0           #bufferedWriter:Ljava/io/BufferedWriter;
    :catch_0
    move-exception v2

    move-object v1, v2

    .line 119
    .local v1, e:Ljava/io/IOException;
    invoke-virtual {p0}, Lcom/tweakaio/TweakAIOActivity;->finish()V

    .line 120
    new-instance v2, Ljava/lang/IllegalStateException;

    invoke-direct {v2, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/Throwable;)V

    throw v2
.end method

.method private writeAllDataToFile(Ljava/io/BufferedWriter;)V
    .locals 4
    .parameter "bufferedWriter"
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .prologue
    .line 126
    iget-object v3, p0, Lcom/tweakaio/TweakAIOActivity;->textData:Ljava/util/List;

    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    .local v0, i$:Ljava/util/Iterator;
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_2

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    .line 128
    .local v1, text:Ljava/lang/String;
    const-string v3, ""

    invoke-virtual {v1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_0

    const-string v3, "#"

    invoke-virtual {v1, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 129
    :cond_0
    move-object v2, v1

    .line 133
    .local v2, valueToWrite:Ljava/lang/String;
    :goto_1
    invoke-virtual {p1, v2}, Ljava/io/BufferedWriter;->write(Ljava/lang/String;)V

    .line 134
    invoke-virtual {p1}, Ljava/io/BufferedWriter;->newLine()V

    goto :goto_0

    .line 131
    .end local v2           #valueToWrite:Ljava/lang/String;
    :cond_1
    invoke-direct {p0, v1}, Lcom/tweakaio/TweakAIOActivity;->getValueFromWidget(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .restart local v2       #valueToWrite:Ljava/lang/String;
    goto :goto_1

    .line 136
    .end local v1           #text:Ljava/lang/String;
    .end local v2           #valueToWrite:Ljava/lang/String;
    :cond_2
    return-void
.end method


# virtual methods
.method public onCreate(Landroid/os/Bundle;)V
    .locals 2
    .parameter "savedInstanceState"

    .prologue
    .line 23
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 24
    const/high16 v0, 0x7f03

    invoke-virtual {p0, v0}, Lcom/tweakaio/TweakAIOActivity;->setContentView(I)V

    .line 25
    const v0, 0x7f050001

    invoke-virtual {p0, v0}, Lcom/tweakaio/TweakAIOActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/LinearLayout;

    iput-object v0, p0, Lcom/tweakaio/TweakAIOActivity;->linearLayout:Landroid/widget/LinearLayout;

    .line 26
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/tweakaio/TweakAIOActivity;->textData:Ljava/util/List;

    .line 27
    invoke-direct {p0}, Lcom/tweakaio/TweakAIOActivity;->showFile()V

    .line 29
    const v0, 0x7f050002

    invoke-virtual {p0, v0}, Lcom/tweakaio/TweakAIOActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    iput-object v0, p0, Lcom/tweakaio/TweakAIOActivity;->saveButton:Landroid/widget/Button;

    .line 30
    iget-object v0, p0, Lcom/tweakaio/TweakAIOActivity;->saveButton:Landroid/widget/Button;

    new-instance v1, Lcom/tweakaio/TweakAIOActivity$1;

    invoke-direct {v1, p0}, Lcom/tweakaio/TweakAIOActivity$1;-><init>(Lcom/tweakaio/TweakAIOActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 36
    return-void
.end method
