unit u_MarksExplorerView;

interface

uses
  Windows,
  Types,
  SysUtils,
  Classes,
  Controls,
  Menus,
  ExtCtrls,
  System.Generics.Collections,
  VirtualTrees,
  VirtualTrees.Types,
  VirtualTrees.BaseTree,
  i_Category,
  i_MapViewGoto,
  i_MarkId,
  i_MarkDb,
  i_MarkCategory,
  i_MarkCategoryList,
  i_MarkCategoryTree,
  i_VectorDataItemSimple,
  i_InterfaceListStatic,
  i_InterfaceListSimple,
  i_MarksExplorerFilter,
  u_MarksExplorerHelper,
  u_MarkDbGUIHelper;

type
  TMarksExplorerViewCount = record
    Selected: Integer;
    Visible: Integer;
    Total: Integer;
  end;
  PMarksExplorerViewCount = ^TMarksExplorerViewCount;

  TMarksExplorerViewScrollInfo = record
    MarksOffsetY: Integer;
    CategoriesOffsetY: Integer;
  end;

  TMarksExplorerView = class
  private type
    TCategoryNodeData = record
      Category: IMarkCategoryTree;
    end;
    PCategoryNodeData = ^TCategoryNodeData;

    TMarksExplorerViewState = record
      IsValid: Boolean;
      IsFocused: Boolean;
      FocusedIndex: Cardinal;
      SelectedIndex: TArray<Cardinal>;
      ScrollOffsetY: TDimension;
      TreeItemsCount: Cardinal;
    end;
    PMarksExplorerViewState = ^TMarksExplorerViewState;
  private
    FMapGoto: IMapViewGoto;
    FMarkDBGUI: TMarkDbGUIHelper;
    FMarksExplorerFilter: IMarksExplorerFilter;

    FCategoryTree: TVirtualStringTree;
    FMarksTree: TVirtualStringTree;

    FMarkCategoryTree: IMarkCategoryTree;
    FMarksList: IInterfaceListStatic;

    FMarksTreeState: TMarksExplorerViewState;

    FCategoriesCount: TMarksExplorerViewCount;
    FMarksCount: TMarksExplorerViewCount;

    FExpandedCategoriesInfo: TCategoryInfoArray;
    FSelectedCategoriesInfo: TCategoryInfo;

    FCascadeChange: Boolean;
    FOnMarksViewChange: TNotifyEvent;
    FOnCategoritesViewChange: TNotifyEvent;

    // Category tree event handlers
    procedure CategoryTreeInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure CategoryTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure CategoryTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure CategoryTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure CategoryTreeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CategoryTreeContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure CategoryTreeDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure CategoryTreeDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: TVTDragDataObject; Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure CategoryTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);

    // Marks tree event handlers
    procedure MarksTreeInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure MarksTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure MarksTreeDblClick(Sender: TObject);
    procedure MarksTreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MarksTreeContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure MarksTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);

    // Helper methods
    procedure CategoryTreeViewModifyVisible(Node: PVirtualNode);

    function GetNodeCategory(const ANode: PVirtualNode): IMarkCategory;
    function GetNodeMarkId(const ANode: PVirtualNode): IMarkId;

    class procedure BeginUpdateTree(const ATree: TVirtualStringTree; const AState: PMarksExplorerViewState);
    class procedure EndUpdateTree(const ATree: TVirtualStringTree; const AState: PMarksExplorerViewState);
  public
    procedure UpdateCategoryTree;
    procedure UpdateMarksList;

    function GetSelectedCategory: IMarkCategory;
    function GetSelectedMarkId: IMarkId;
    function GetSelectedMarkFull: IVectorDataItem;
    function GetSelectedMarksIdList(const ASorted: Boolean = False): IInterfaceListStatic;
    function GetSelectedMarksIdArray(const ASorted: Boolean = False): TArrayOfMarkId;

    procedure SelectAllVisibleMarks;
    procedure RevertSelectedMarks;

    function GetCategoriesCount: PMarksExplorerViewCount;
    function GetMarksCount: PMarksExplorerViewCount;

    procedure GetCategoriesState(var AExpanded: TCategoryInfoArray; var ASelected: TCategoryInfo);
    procedure RestoreCategoriesState(const AExpanded: TCategoryInfoArray; const ASelected: TCategoryInfo);

    function GetScrollInfo: TMarksExplorerViewScrollInfo;
    procedure SetScrollInfo(const AValue: TMarksExplorerViewScrollInfo);

    procedure Reset;

    property CascadeChange: Boolean read FCascadeChange write FCascadeChange;

    property ScrollInfo: TMarksExplorerViewScrollInfo read GetScrollInfo write SetScrollInfo;

    property OnMarksViewChange: TNotifyEvent read FOnMarksViewChange write FOnMarksViewChange;
    property OnCategoritesViewChange: TNotifyEvent read FOnCategoritesViewChange write FOnCategoritesViewChange;
  public
    constructor Create(
      const ACategoriesPanel: TPanel;
      const ACategoriesPopupMenu: TPopupMenu;
      const AMarksPanel: TPanel;
      const AMarksPopupMenu: TPopupMenu;
      const AMapGoto: IMapViewGoto;
      const AMarkDBGUI: TMarkDbGUIHelper;
      const AMarksExplorerFilter: IMarksExplorerFilter
    );
    destructor Destroy; override;
  end;

implementation

uses
  CityHash,
  ExplorerSort,
  i_MarkCategoryDB,
  i_MarkCategoryFactory,
  u_MarkCategoryList,
  u_InterfaceListSimple,
  u_SortFunc;

constructor TMarksExplorerView.Create(
  const ACategoriesPanel: TPanel;
  const ACategoriesPopupMenu: TPopupMenu;
  const AMarksPanel: TPanel;
  const AMarksPopupMenu: TPopupMenu;
  const AMapGoto: IMapViewGoto;
  const AMarkDBGUI: TMarkDbGUIHelper;
  const AMarksExplorerFilter: IMarksExplorerFilter
);
begin
  inherited Create;

  FMapGoto := AMapGoto;
  FMarkDBGUI := AMarkDBGUI;
  FMarksExplorerFilter := AMarksExplorerFilter;

  // Create category tree
  FCategoryTree := TVirtualStringTree.Create(nil);
  FCategoryTree.Parent := ACategoriesPanel;
  FCategoryTree.Align := alClient;
  FCategoryTree.NodeDataSize := SizeOf(TCategoryNodeData);
  FCategoryTree.TreeOptions.MiscOptions := FCategoryTree.TreeOptions.MiscOptions + [toCheckSupport];
  FCategoryTree.TreeOptions.SelectionOptions := FCategoryTree.TreeOptions.SelectionOptions + [toFullRowSelect];
  FCategoryTree.TreeOptions.PaintOptions := FCategoryTree.TreeOptions.PaintOptions + [toShowRoot, toShowTreeLines];
  FCategoryTree.DragMode := dmAutomatic;
  FCategoryTree.DragType := dtVCL;
  FCategoryTree.Header.Options := FCategoryTree.Header.Options - [hoVisible];
  FCategoryTree.PopupMenu := ACategoriesPopupMenu;

  FCategoryTree.OnInitNode := CategoryTreeInitNode;
  FCategoryTree.OnFreeNode := CategoryTreeFreeNode;
  FCategoryTree.OnGetText := CategoryTreeGetText;
  FCategoryTree.OnChange := CategoryTreeChange;
  FCategoryTree.OnKeyUp := CategoryTreeKeyUp;
  FCategoryTree.OnContextPopup := CategoryTreeContextPopup;
  FCategoryTree.OnDragOver := CategoryTreeDragOver;
  FCategoryTree.OnDragDrop := CategoryTreeDragDrop;
  FCategoryTree.OnChecked := CategoryTreeChecked;

  // Create marks tree
  FMarksTree := TVirtualStringTree.Create(nil);
  FMarksTree.Parent := AMarksPanel;
  FMarksTree.Align := alClient;
  FMarksTree.NodeDataSize := 0;
  FMarksTree.TreeOptions.MiscOptions := FMarksTree.TreeOptions.MiscOptions + [toCheckSupport];
  FMarksTree.TreeOptions.SelectionOptions := FMarksTree.TreeOptions.SelectionOptions + [toFullRowSelect, toMultiSelect];
  FMarksTree.TreeOptions.PaintOptions := FMarksTree.TreeOptions.PaintOptions - [toShowRoot, toShowTreeLines];
  FMarksTree.DragMode := dmAutomatic;
  FMarksTree.DragType := dtVCL;
  FMarksTree.Header.Options := FMarksTree.Header.Options - [hoVisible];
  FMarksTree.PopupMenu := AMarksPopupMenu;

  FMarksTree.OnInitNode := MarksTreeInitNode;
  FMarksTree.OnFreeNode := nil;
  FMarksTree.OnGetText := MarksTreeGetText;
  FMarksTree.OnDblClick := MarksTreeDblClick;
  FMarksTree.OnKeyDown := MarksTreeKeyDown;
  FMarksTree.OnContextPopup := MarksTreeContextPopup;
  FMarksTree.OnChecked := MarksTreeChecked;
end;

destructor TMarksExplorerView.Destroy;
begin
  FreeAndNil(FMarksTree);
  FreeAndNil(FCategoryTree);
  inherited Destroy;
end;

procedure TMarksExplorerView.Reset;
begin
  FMarksTree.Clear;
  FCategoryTree.Clear;

  FMarksList := nil;
  FMarkCategoryTree := nil;

  FExpandedCategoriesInfo := nil;
  FSelectedCategoriesInfo.UID := 0;
end;

function TMarksExplorerView.GetCategoriesCount: PMarksExplorerViewCount;
begin
  Result := @FCategoriesCount;
  Result.Selected := FCategoryTree.SelectedCount;
end;

function TMarksExplorerView.GetMarksCount: PMarksExplorerViewCount;
begin
  Result := @FMarksCount;
  Result.Selected := FMarksTree.SelectedCount;
end;

{$REGION 'Category tree event handlers'}
procedure TMarksExplorerView.CategoryTreeInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  VNodeData: PCategoryNodeData;
  VParentData: PCategoryNodeData;
  VParentCategory: IMarkCategoryTree;
begin
  VNodeData := Sender.GetNodeData(Node);

  if ParentNode = nil then begin
    // Root node
    if Assigned(FMarkCategoryTree) and (Node.Index < Cardinal(FMarkCategoryTree.SubItemCount)) then begin
      VNodeData.Category := FMarkCategoryTree.SubItem[Node.Index];
    end;
  end else begin
    // Child node
    VParentData := Sender.GetNodeData(ParentNode);
    if Assigned(VParentData) then begin
      VParentCategory := VParentData.Category;
      if Assigned(VParentCategory) and (Node.Index < Cardinal(VParentCategory.SubItemCount)) then begin
        VNodeData.Category := VParentCategory.SubItem[Node.Index];
      end;
    end;
  end;

  // Set child count for tree expansion
  if Assigned(VNodeData.Category) then begin
    Sender.ChildCount[Node] := VNodeData.Category.SubItemCount;
  end;

  Node.CheckType := ctCheckBox;

  // Set checkbox state based on visibility
  if VNodeData.Category.MarkCategory.Visible then begin
    Node.CheckState := csCheckedNormal;
  end else begin
    Node.CheckState := csUncheckedNormal;
  end;
end;

procedure TMarksExplorerView.CategoryTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  VNodeData: PCategoryNodeData;
begin
  VNodeData := Sender.GetNodeData(Node);
  if Assigned(VNodeData) then begin
    VNodeData.Category := nil;
  end;
end;

procedure TMarksExplorerView.CategoryTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  VName: string;
  VNodeData: PCategoryNodeData;
begin
  VNodeData := Sender.GetNodeData(Node);
  if Assigned(VNodeData) and Assigned(VNodeData.Category) then begin
    VName := VNodeData.Category.Name;
    if VName = '' then begin
      VName := '(NoName)';
    end;
    CellText := VName;
  end else begin
    CellText := '';
  end;
end;

procedure TMarksExplorerView.CategoryTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  UpdateMarksList;
end;

procedure TMarksExplorerView.CategoryTreeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  VNode: PVirtualNode;
begin
  // Note: VK_F2 (Edit) and VK_DEL (Delete) keys are handled by parent

  if Key = VK_SPACE then begin
    VNode := FCategoryTree.GetFirstSelected;
    if VNode <> nil then begin
      CategoryTreeViewModifyVisible(VNode);
    end;
    Key := 0;
  end;
end;

procedure TMarksExplorerView.CategoryTreeContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
  VNode: PVirtualNode;
begin
  if (MousePos.X >= 0) and (MousePos.Y >= 0) then begin
    VNode := FCategoryTree.GetNodeAt(MousePos.X, MousePos.Y);
    if VNode <> nil then begin
      FCategoryTree.Selected[VNode] := True;
      FCategoryTree.FocusedNode := VNode;
    end;
  end;
end;

procedure TMarksExplorerView.CategoryTreeDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
var
  I: Integer;
  VNode: PVirtualNode;
  VList: IMarkCategoryList;
  VNewName: string;
  VOldCategory, VOldSubCategory, VNewCategory: IMarkCategory;
begin
  Accept := (Source = FMarksTree) or (Source = FCategoryTree);
  if not Accept then begin
    Exit;
  end;

  VNode := Sender.GetNodeAt(Pt.X, Pt.Y);
  Accept := (VNode <> nil) and (VNode <> Sender.GetFirstSelected);
  if not Accept then begin
    Exit;
  end;

  if Source = FCategoryTree then begin
    VOldCategory := GetNodeCategory(Sender.GetFirstSelected);
    VNewCategory := GetNodeCategory(VNode);
    Accept := (VOldCategory <> nil) and (VNewCategory <> nil);
    if not Accept then begin
      Exit;
    end;

    VNewName := VOldCategory.Name;
    I := LastDelimiter('\', VNewName);
    VNewName := VNewCategory.Name + '\' + Copy(VNewName, I + 1, MaxInt);
    Accept := FMarkDBGUI.MarksDb.CategoryDB.GetFirstCategoryByName(VNewName) = nil;
    if not Accept then begin
      Exit;
    end;

    // Forbid the transfer of a category to its own child category
    VList := FMarkDBGUI.MarksDb.CategoryDB.GetSubCategoryListForCategory(VOldCategory);
    if VList <> nil then begin
      for I := 0 to VList.Count - 1 do begin
        VOldSubCategory := IMarkCategory(VList[I]);
        if VNewCategory.IsSame(VOldSubCategory) then begin
          Accept := False;
          Break;
        end;
      end;
    end;
  end else
  if Source = FMarksTree then begin
    if Mode <> dmOnNode then begin
      Accept := False;
    end;
  end;
end;

procedure TMarksExplorerView.CategoryTreeDragDrop(Sender: TBaseVirtualTree; Source: TObject;
  DataObject: TVTDragDataObject; Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer;
  Mode: TDropMode);

  function MoveMarks(
    const ADestNode: PVirtualNode;
    const AMarks: IInterfaceListStatic
  ): Boolean;
  var
    I: Integer;
    VMarkIdListNew: IInterfaceListSimple;
    VCategoryNew: ICategory;
    VMark: IVectorDataItem;
  begin
    Result := False;
    if AMarks <> nil then begin
      VCategoryNew := GetNodeCategory(ADestNode);
      if VCategoryNew <> nil then begin
        VMarkIdListNew := TInterfaceListSimple.Create;
        for I := 0 to AMarks.Count - 1 do begin
          VMark := FMarkDBGUI.MarksDb.MarkDb.GetMarkByID(IMarkId(AMarks.Items[I]));
          VMarkIdListNew.Add(FMarkDBGUI.MarksDb.MarkDb.Factory.ReplaceCategory(VMark, VCategoryNew));
        end;
        FMarkDBGUI.MarksDb.MarkDb.UpdateMarkList(AMarks, VMarkIdListNew.MakeStaticAndClear);
        Result := True;
      end;
    end;
  end;

  procedure MoveCategory(const ADestNode, ASourceNode: PVirtualNode);
  var
    I: Integer;
    VNewName: string;
    VDestCategory: ICategory;
    VOldCategory, VNewCategory: IMarkCategory;
  begin
    VDestCategory := GetNodeCategory(ADestNode);
    VOldCategory := GetNodeCategory(ASourceNode);
    if (VDestCategory <> nil) and (VOldCategory <> nil) then begin
      // Get new name for category
      VNewName := VOldCategory.Name;
      I := LastDelimiter('\', VNewName);
      VNewName := VDestCategory.Name + '\' + Copy(VNewName, I + 1, MaxInt);

      // Modify category with all subcategories
      VNewCategory := FMarkDBGUI.MarksDb.CategoryDB.Factory.Modify(
        VOldCategory,
        VNewName,
        VOldCategory.Visible,
        VOldCategory.AfterScale,
        VOldCategory.BeforeScale
      );
      FMarkDBGUI.MarksDb.CategoryDB.UpdateCategory(VOldCategory, VNewCategory);
    end;
  end;

var
  VNode: PVirtualNode;
begin
  VNode := Sender.GetNodeAt(Pt.X, Pt.Y);
  if (VNode <> nil) and (VNode <> Sender.GetFirstSelected) then begin
    if Source = FMarksTree then begin
      // Replace category for all selected marks in selected category
      if MoveMarks(VNode, GetSelectedMarksIdList) then begin
        FMarksTree.ClearSelection;
      end;
    end else if Source = FCategoryTree then begin
      // Move selected category with all subcategories to new category
      MoveCategory(VNode, Sender.GetFirstSelected);
    end;
  end;
end;

procedure TMarksExplorerView.CategoryTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  FCategoryTree.ClearSelection;
  FCategoryTree.Selected[Node] := True;
  FCategoryTree.FocusedNode := Node;

  CategoryTreeViewModifyVisible(Node);
end;

procedure TMarksExplorerView.CategoryTreeViewModifyVisible(Node: PVirtualNode);
var
  I: Integer;
  VNewVisible: Boolean;
  VCategoryOld: IMarkCategory;
  VCategoryNew: IMarkCategory;
  VOldList, VNewList: IMarkCategoryList;
  VTempOld, VTempNew: IInterfaceListSimple;
  VFactory: IMarkCategoryFactory;
  VCategoryDB: IMarkCategoryDB;
begin
  VCategoryOld := GetNodeCategory(Node);
  if VCategoryOld = nil then begin
    Exit;
  end;

  VNewVisible := Node.CheckState = csCheckedNormal;

  VTempOld := TInterfaceListSimple.Create;
  VTempNew := TInterfaceListSimple.Create;
  VCategoryDB := FMarkDBGUI.MarksDb.CategoryDB;
  VFactory := VCategoryDB.Factory;

  // Change Visible property for current category node
  if VCategoryOld.Visible <> VNewVisible then begin
    VCategoryNew := VFactory.ModifyVisible(VCategoryOld, VNewVisible);
    VTempOld.Add(VCategoryOld);
    VTempNew.Add(VCategoryNew);
  end;

  // Change Visible property for child categories if cascade mode is enabled
  if FCascadeChange then begin
    VOldList := VCategoryDB.GetSubCategoryListForCategory(VCategoryOld);
    if Assigned(VOldList) then begin
      for I := 0 to VOldList.Count - 1 do begin
        VCategoryOld := VOldList.Items[I];
        if VCategoryOld.Visible <> VNewVisible then begin
          VCategoryNew := VFactory.ModifyVisible(VCategoryOld, VNewVisible);
          VTempOld.Add(VCategoryOld);
          VTempNew.Add(VCategoryNew);
        end;
      end;
    end;
  end;

  // Apply changes
  if VTempOld.Count > 1 then begin
    VOldList := TMarkCategoryList.Build(VTempOld.MakeStaticAndClear);
    VNewList := TMarkCategoryList.Build(VTempNew.MakeStaticAndClear);
    VCategoryDB.UpdateCategoryList(VOldList, VNewList);
  end else
  if VTempOld.Count = 1 then begin
    VCategoryDB.UpdateCategory(IMarkCategory(VTempOld.Items[0]), IMarkCategory(VTempNew.Items[0]));
  end;
end;
{$ENDREGION}

{$REGION 'Marks tree event handlers'}
procedure TMarksExplorerView.MarksTreeInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  VMarkId: IMarkId;
begin
  VMarkId := GetNodeMarkId(Node);

  if not Assigned(VMarkId) then begin
    Exit;
  end;

  Node.CheckType := ctCheckBox;

  if FMarkDBGUI.MarksDb.MarkDb.GetMarkVisibleByID(VMarkId) then begin
    Node.CheckState := csCheckedNormal;
  end else begin
    Node.CheckState := csUncheckedNormal;
  end;
end;

procedure TMarksExplorerView.MarksTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  VMarkId: IMarkId;
begin
  VMarkId := GetNodeMarkId(Node);

  if Assigned(VMarkId) then begin
    CellText := FMarkDBGUI.MakeMarkCaption(VMarkId);
  end else begin
    CellText := '';
  end;
end;

procedure TMarksExplorerView.MarksTreeDblClick(Sender: TObject);
var
  VMark: IVectorDataItem;
begin
  VMark := GetSelectedMarkFull;
  if Assigned(VMark) and Assigned(VMark.Geometry.Bounds) then begin
    FMapGoto.FitRectToScreen(VMark.Geometry.Bounds.Rect);
    FMapGoto.ShowMarker(VMark.Geometry.GetGoToPoint);
  end;
end;

procedure TMarksExplorerView.MarksTreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  VMarkIdList: IInterfaceListStatic;
begin
  // Note: VK_F2 (Edit) and VK_DEL (Delete) keys are handled by parent

  if Key = VK_SPACE then begin
    VMarkIdList := GetSelectedMarksIdList;
    if (VMarkIdList <> nil) and (VMarkIdList.Count > 0) then begin
      FMarkDBGUI.MarksDb.MarkDb.ToggleMarkVisibleByIDList(VMarkIdList);
    end;
    Key := 0;
  end else
  if Key = VK_RETURN then begin
    MarksTreeDblClick(Sender);
    Key := 0;
  end;
end;

procedure TMarksExplorerView.MarksTreeContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
  VNode: PVirtualNode;
begin
  if (MousePos.X >= 0) and (MousePos.Y >= 0) then begin
    VNode := FMarksTree.GetNodeAt(MousePos.X, MousePos.Y);
    if VNode <> nil then begin
      if not FMarksTree.Selected[VNode] then begin
        FMarksTree.ClearSelection;
        FMarksTree.Selected[VNode] := True;
        FMarksTree.FocusedNode := VNode;
      end;
    end;
  end;
end;

procedure TMarksExplorerView.MarksTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  VMarkId: IMarkId;
begin
  FMarksTree.ClearSelection;
  FMarksTree.Selected[Node] := True;
  FMarksTree.FocusedNode := Node;

  VMarkId := GetNodeMarkId(Node);
  if Assigned(VMarkId) then begin
    FMarkDBGUI.MarksDb.MarkDb.SetMarkVisibleByID(VMarkId, Node.CheckState = csCheckedNormal);
  end;
end;
{$ENDREGION}

procedure TMarksExplorerView.UpdateCategoryTree;
var
  VScrollOffsetY: TDimension;
  VCategoryList: IMarkCategoryList;
  VCategoryDB: IMarkCategoryDB;
begin
  VCategoryDB := FMarkDBGUI.MarksDb.CategoryDB;
  VCategoryList := VCategoryDB.GetCategoriesList;

  FMarkCategoryTree := VCategoryDB.CategoryListToStaticTree(VCategoryList);

  FCategoryTree.OnChange := nil;
  try
    FCategoryTree.BeginUpdate;
    try
      VScrollOffsetY := FCategoryTree.OffsetY;
      GetCategoriesState(FExpandedCategoriesInfo, FSelectedCategoriesInfo);

      FCategoryTree.Clear;

      if Assigned(FMarkCategoryTree) then begin
        FCategoryTree.RootNodeCount := FMarkCategoryTree.SubItemCount;
      end;

      RestoreCategoriesState(FExpandedCategoriesInfo, FSelectedCategoriesInfo);
      FCategoryTree.OffsetY := VScrollOffsetY;
    finally
      FCategoryTree.EndUpdate;
    end;
  finally
    FCategoryTree.OnChange := CategoryTreeChange;
  end;

  if Assigned(FOnCategoritesViewChange) then begin
    FOnCategoritesViewChange(nil);
  end;

  UpdateMarksList;
end;

procedure TMarksExplorerView.UpdateMarksList;

  procedure SortMarksByName(var AMarksList: IInterfaceListStatic);
  var
    I: Integer;
    VList: IInterfaceListSimple;
    VMeasure: array of string;
  begin
    if AMarksList.Count > 0 then begin
      SetLength(VMeasure, AMarksList.Count);
      for I := 0 to AMarksList.Count - 1 do begin
        VMeasure[I] := FMarkDBGUI.MakeMarkCaption(IMarkId(AMarksList.Items[I]));
      end;
      VList := TInterfaceListSimple.Create;
      VList.AddListStatic(AMarksList);
      SortInterfaceListByStringMeasure(VList, VMeasure);
      AMarksList := VList.MakeStaticAndClear;
    end;
  end;

  procedure UpdateMarksCount(const AVisibleCount: Integer);
  begin
    FMarksCount.Selected := FMarksTree.SelectedCount;
    FMarksCount.Visible := AVisibleCount;
    if Assigned(FMarksList) then begin
      FMarksCount.Total := FMarksList.Count;
    end else begin
      FMarksCount.Total := -1;
    end;
  end;

var
  I: Integer;
  VMarkDb: IMarkDb;
  VCategory: IMarkCategory;
  VVisibleCount: Integer;
begin
  FMarksList := nil;
  VCategory := GetSelectedCategory;

  VVisibleCount := 0;

  BeginUpdateTree(FMarksTree, @FMarksTreeState);
  try
    FMarksTree.Clear;

    if Assigned(VCategory) then begin
      VMarkDb := FMarkDBGUI.MarksDb.MarkDb;
      FMarksList := FMarksExplorerFilter.Process(VMarkDb, VMarkDb.GetMarkIdListByCategory(VCategory));

      if Assigned(FMarksList) then begin
        SortMarksByName(FMarksList);

        FMarksTree.RootNodeCount := FMarksList.Count;

        for I := 0 to FMarksList.Count - 1 do begin
          if VMarkDb.GetMarkVisibleByID(IMarkId(FMarksList.Items[I])) then begin
            Inc(VVisibleCount);
          end;
        end;
      end;
    end;

    UpdateMarksCount(VVisibleCount);
  finally
    EndUpdateTree(FMarksTree, @FMarksTreeState);
  end;

  if Assigned(FOnMarksViewChange) then begin
    FOnMarksViewChange(nil);
  end;
end;

function TMarksExplorerView.GetNodeCategory(const ANode: PVirtualNode): IMarkCategory;
var
  NodeData: PCategoryNodeData;
begin
  Result := nil;
  if ANode <> nil then begin
    NodeData := FCategoryTree.GetNodeData(ANode);
    if Assigned(NodeData) then begin
      Result := NodeData.Category.MarkCategory;
    end;
  end;
end;

function TMarksExplorerView.GetNodeMarkId(const ANode: PVirtualNode): IMarkId;
begin
  if Assigned(FMarksList) and Assigned(ANode) and (ANode.Index < Cardinal(FMarksList.Count)) then begin
    Result := IMarkId(FMarksList.Items[ANode.Index]);
  end else begin
    Result := nil;
    Assert(False);
  end;
end;

function TMarksExplorerView.GetSelectedCategory: IMarkCategory;
var
  VNode: PVirtualNode;
begin
  VNode := FCategoryTree.GetFirstSelected;
  if VNode <> nil then begin
    Result := GetNodeCategory(VNode);
  end else begin
    Result := nil;
  end;
end;

function TMarksExplorerView.GetSelectedMarkFull: IVectorDataItem;
var
  VMarkId: IMarkId;
begin
  VMarkId := GetSelectedMarkId;
  if VMarkId <> nil then begin
    Result := FMarkDBGUI.MarksDb.MarkDb.GetMarkByID(VMarkId);
  end else begin
    Result := nil;
  end;
end;

function TMarksExplorerView.GetSelectedMarksIdList(const ASorted: Boolean): IInterfaceListStatic;
var
  I: Integer;
  VArr: TArrayOfMarkId;
  VList: IInterfaceListSimple;
begin
  Result := nil;
  VArr := GetSelectedMarksIdArray(ASorted);
  if Length(VArr) > 0 then begin
    VList := TInterfaceListSimple.Create;
    for I := 0 to Length(VArr) - 1 do begin
      VList.Add(VArr[I]);
    end;
    Result := VList.MakeStaticAndClear;
  end;
end;

function TMarksExplorerView.GetSelectedMarksIdArray(const ASorted: Boolean): TArrayOfMarkId;
var
  I: Integer;
  VArr: TArrayOfMarkId;
  VNode: PVirtualNode;
  VName: string;
  VSortedList: TStringList;
  VCount: Integer;
begin
  VCount := FMarksTree.SelectedCount;
  SetLength(Result, VCount);

  if VCount = 0 then begin
    Exit;
  end;

  I := 0;
  VNode := FMarksTree.GetFirstSelected;
  while VNode <> nil do begin
    Result[I] := GetNodeMarkId(VNode);
    if Assigned(Result[I]) then begin
      Inc(I);
    end;
    VNode := FMarksTree.GetNextSelected(VNode);
  end;

  SetLength(Result, I);

  if not ASorted or (Length(Result) < 2) then begin
    Exit;
  end;

  VArr := Copy(Result);

  VSortedList := TStringList.Create;
  try
    VSortedList.Duplicates := dupAccept;
    VSortedList.BeginUpdate;
    try
      for I := 0 to Length(VArr) - 1 do begin
        VName := FMarkDBGUI.MakeMarkCaption(VArr[I]);
        VSortedList.AddObject(VName, TObject(UIntPtr(I)));
      end;
      VSortedList.CustomSort(StringListCompare);
    finally
      VSortedList.EndUpdate;
    end;

    for I := 0 to VSortedList.Count - 1 do begin
      Result[I] := VArr[UIntPtr(VSortedList.Objects[I])];
    end;
  finally
    VSortedList.Free;
  end;
end;

function TMarksExplorerView.GetSelectedMarkId: IMarkId;
var
  VNode: PVirtualNode;
begin
  VNode := FMarksTree.GetFirstSelected;
  if VNode <> nil then begin
    Result := GetNodeMarkId(VNode);
  end else begin
    Result := nil;
  end;
end;

procedure TMarksExplorerView.SelectAllVisibleMarks;
var
  VNode: PVirtualNode;
begin
  FMarksTree.BeginUpdate;
  try
    VNode := FMarksTree.GetFirst;
    while VNode <> nil do begin
      FMarksTree.Selected[VNode] := (VNode.CheckState = csCheckedNormal);
      VNode := FMarksTree.GetNext(VNode);
    end;
  finally
    FMarksTree.EndUpdate;
  end;
end;

procedure TMarksExplorerView.RevertSelectedMarks;
var
  VNode: PVirtualNode;
  VWasSelected: Boolean;
begin
  FMarksTree.BeginUpdate;
  try
    VNode := FMarksTree.GetFirst;
    while VNode <> nil do begin
      VWasSelected := FMarksTree.Selected[VNode];
      FMarksTree.Selected[VNode] := not VWasSelected;
      VNode := FMarksTree.GetNext(VNode);
    end;
  finally
    FMarksTree.EndUpdate;
  end;
end;

procedure TMarksExplorerView.GetCategoriesState(var AExpanded: TCategoryInfoArray; var ASelected: TCategoryInfo);
var
  I: Integer;
  VLen: Integer;
  VNode: PVirtualNode;
  VNodeData: PCategoryNodeData;
  VNodeIndex: Integer;
begin
  I := 0;
  VLen := 64;
  SetLength(AExpanded, VLen);

  ASelected.UID := 0;
  ASelected.Index := -1;

  VNodeIndex := 0;
  VNode := FCategoryTree.GetFirst;

  while VNode <> nil do begin
    VNodeData := nil;

    // Expanded
    if FMarksTree.Expanded[VNode] then begin
      VNodeData := FCategoryTree.GetNodeData(VNode);
      if (VNodeData <> nil) and (VNodeData.Category <> nil) then begin
        if I >= VLen then begin
          VLen := GrowCollection(VLen, I);
          SetLength(AExpanded, VLen);
        end;

        AExpanded[I].Index := VNodeIndex;
        AExpanded[I].UID := GetNodeUniqueID(VNodeData.Category.MarkCategory);

        if AExpanded[I].UID <> 0 then begin
          Inc(I);
        end;
      end;
    end;

    // Selected
    if (ASelected.UID = 0) and FMarksTree.Selected[VNode] then begin
      if VNodeData = nil then begin
        VNodeData := FCategoryTree.GetNodeData(VNode);
      end;
      if (VNodeData <> nil) and (VNodeData.Category <> nil) then begin
        ASelected.Index := VNodeIndex;
        ASelected.UID := GetNodeUniqueID(VNodeData.Category.MarkCategory);
      end;
    end;

    VNode := FCategoryTree.GetNext(VNode);
    Inc(VNodeIndex);
  end;

  SetLength(AExpanded, I);
end;

procedure TMarksExplorerView.RestoreCategoriesState(const AExpanded: TCategoryInfoArray; const ASelected: TCategoryInfo);
var
  VNode: PVirtualNode;
  VNodeData: PCategoryNodeData;
  VNodeIndex: Integer;
  VExpandedLen: Integer;
  VExpandedIndex: Integer;
  VSelectedFound: Boolean;
begin
  VExpandedLen := Length(AExpanded);
  VExpandedIndex := 0;

  VSelectedFound := (ASelected.UID = 0);

  if (VExpandedLen = 0) and (VSelectedFound) then begin
    Exit;
  end;

  VNodeIndex := 0;
  VNode := FCategoryTree.GetFirst;

  while VNode <> nil do begin
    VNodeData := nil;

    // Expanded (search algorithm requires the AExpanded array to be pre-sorted by the Index field)
    if (VExpandedIndex < VExpandedLen) and (VNodeIndex = AExpanded[VExpandedIndex].Index) then begin
      VNodeData := FCategoryTree.GetNodeData(VNode);
      if (VNodeData <> nil) and (VNodeData.Category <> nil) then begin
        if AExpanded[VExpandedIndex].UID = GetNodeUniqueID(VNodeData.Category.MarkCategory) then begin
          FCategoryTree.Expanded[VNode] := True;
        end;
      end;
      Inc(VExpandedIndex);
    end;

    // Selected
    if (not VSelectedFound) and (VNodeIndex = ASelected.Index) then begin
      if VNodeData = nil then begin
        VNodeData := FCategoryTree.GetNodeData(VNode);
      end;
      if (VNodeData <> nil) and (VNodeData.Category <> nil) then begin
        if ASelected.UID = GetNodeUniqueID(VNodeData.Category.MarkCategory) then begin
          FCategoryTree.ClearSelection;
          FCategoryTree.Selected[VNode] := True;
          VSelectedFound := True;
        end;
      end;
    end;

    if VSelectedFound and (VExpandedIndex >= VExpandedLen) then begin
      // All done
      Break;
    end;

    VNode := FCategoryTree.GetNext(VNode);
    Inc(VNodeIndex);
  end;
end;

function TMarksExplorerView.GetScrollInfo: TMarksExplorerViewScrollInfo;
begin
  Result.MarksOffsetY := FMarksTree.OffsetY;
  Result.CategoriesOffsetY := FCategoryTree.OffsetY;
end;

procedure TMarksExplorerView.SetScrollInfo(const AValue: TMarksExplorerViewScrollInfo);
begin
  FMarksTree.OffsetY := AValue.MarksOffsetY;
  FCategoryTree.OffsetY := AValue.CategoriesOffsetY;
end;

class procedure TMarksExplorerView.BeginUpdateTree(const ATree: TVirtualStringTree; const AState: PMarksExplorerViewState);
var
  I: Integer;
  VNode: PVirtualNode;
begin
  ATree.BeginUpdate;

  VNode := ATree.FocusedNode;
  if VNode <> nil then begin
    AState.FocusedIndex := VNode.Index;
    AState.IsFocused := True;
  end else begin
    AState.IsFocused := False;
  end;

  I := 0;
  SetLength(AState.SelectedIndex, ATree.SelectedCount);

  for VNode in ATree.SelectedNodes do begin
    AState.SelectedIndex[I] := VNode.Index;
    Inc(I);
  end;

  TArray.Sort<Cardinal>(AState.SelectedIndex); // for binary search

  AState.IsValid := True;
  AState.ScrollOffsetY := ATree.OffsetY;
  AState.TreeItemsCount := ATree.TotalCount;
end;

class procedure TMarksExplorerView.EndUpdateTree(const ATree: TVirtualStringTree; const AState: PMarksExplorerViewState);
var
  I: Integer;
  VNode: PVirtualNode;
begin
  try
    ATree.ClearSelection;
    ATree.OffsetY := AState.ScrollOffsetY;

    if not AState.IsValid then begin
      Assert(False);
      Exit;
    end;

    if AState.TreeItemsCount <> ATree.TotalCount then begin
      Exit;
    end;

    VNode := ATree.GetFirst;
    while VNode <> nil do begin
      // restore selection
      if TArray.BinarySearch<Cardinal>(AState.SelectedIndex, VNode.Index, I) then begin
        ATree.Selected[VNode] := True;
      end;

      // restore focus
      if AState.IsFocused and (VNode.Index = AState.FocusedIndex) then begin
        ATree.FocusedNode := VNode;
      end;

      VNode := ATree.GetNext(VNode);
    end;

    AState.IsValid := False;
    AState.IsFocused := False;
    AState.SelectedIndex := nil;
  finally
    ATree.EndUpdate;
  end;
end;

end.
